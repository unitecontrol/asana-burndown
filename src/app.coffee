path = require 'path'
express = require 'express'
mkdirp = require 'mkdirp'

app = express()

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
app.locals.pretty = true

publicPath = path.join(__dirname, 'public')

app.use require('stylus').middleware publicPath

app.use require('coffee-middleware') publicPath

app.use express.static publicPath

mkdirp.sync "./data/db"

app.use '/', require './routes/index'

app.use '/durations', require('./routes/durations')

require './cron'

server = app.listen 3003, ->
	port = server.address().port

	console.log "Server started on port :#{port}"
