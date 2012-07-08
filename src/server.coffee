net = require 'net'
animation = require '../assets/animation'
chars = require '../assets/characters'

class Server
	clients: 0
	
	constructor: (@port) ->
		@server = net.createServer @client
		@server.listen @port
	
	client: (con) =>
		@clients++
		frame = 0
		
		con.setEncoding 'binary'
		
		con.on 'end', =>
			clearInterval interval
			@clients--
		
		con.on 'data', (data) =>
			switch data.toString('utf8').trim()
				when 'q' then con.end()
				else console.log data
		
		interval = setInterval =>
			if frame is 12
				frame = 0
			
			con.write chars.clean + chars.end + animation[frame++]
		, 150
		
		
		
module.exports = Server