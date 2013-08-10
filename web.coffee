gzippo  = require 'gzippo'
express = require 'express'
request = require 'request'
parser  = require 'parse-rss'
url     = require 'url'
redis   = require 'redis'

if (process.env.REDISTOGO_URL)
  rtg = url.parse(process.env.REDISTOGO_URL)
  rclient = createClient(rtg.port, rtg.hostname)

  rclient.auth(rtg.auth.split(":")[1])
else
  rclient = redis.createClient()

icon_regex_v1 = /div\.filling\{background\-image:url\(([^\)]*)\)\;\}/
color_regex_v1 = /div\.filling\{background\-color:(\#\w+)\}/

icon_regex_v2 = /figure\.logoa\{background:#\S{6}url\(([^\)]*)\)/
color_regex_v2 = /figure\.logoa\{background:(#\S{6})/


rclient.on 'error', (err) =>
  console.log "REDIS ERROR: #{err}"

set_icon = (entry, body, regex) =>
  match = body.match(regex)
  entry.icon_url = match[1] if match

  rclient.hset entry.origlink, 'icon_url', entry.icon_url if match

  return match

set_color = (entry, body, regex) =>
  match = body.match(regex)
  entry.color = match[1] if match

  rclient.hset entry.origlink, 'color', entry.color if match

  return match

app = express()
app.use express.logger 'dev'
app.use gzippo.staticGzip "#{__dirname}/dist"

app.get '/refresh', (req, res) ->
  parser 'http://feeds.feedburner.com/svbtle', (error, rss) =>
    if error
      res.send error
    else
      rss.forEach (entry) =>
        Object.keys(entry).forEach (key) =>
          rclient.hset entry.origlink, key, entry[key]
          rclient.sadd 'entries', entry.origlink
      res.send {status: 'OK'}

app.get('/getfeed', (req, res) ->
  res.header("Access-Control-Allow-Origin", "*")
  res.header("Access-Control-Allow-Headers", "X-Requested-With")
  res.header("Content-Type", "application/json")


  rclient.smembers 'entries', (err, keys) =>
    remaining = keys.length
    rss       = []

    fetch_info = (entry) =>
      request.get entry.origlink, (err, resp, body) =>
        if body
          clean_body = body.replace(/\ |\n|\r|\n\r|\r\n/g, '')

          unless set_icon(entry, clean_body, icon_regex_v1)
            entry.icon_url = null
            set_icon entry, clean_body, icon_regex_v2

          unless set_color  entry, clean_body, color_regex_v1
            entry.color = "#acacac"
            set_color entry, clean_body, color_regex_v2
        else
          entry.icon_url = null
          entry.color    = "#acacac"

        remaining -= 1
        res.send rss if remaining <= 0

    keys.forEach (key) =>
      rclient.hgetall key, (err, entry) =>
        rss.push entry

        unless entry.icon_url and entry.color
          fetch_info entry
        else
          remaining -= 1
          res.send rss if remaining <= 0

)

app.listen process.env.PORT || 9000
