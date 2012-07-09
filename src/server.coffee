net = require 'net'
util = require 'util'
animation = require '../assets/animation'
chars = require '../assets/characters'
messages = require '../assets/messages'

class Server
	# clients: 0
	
	genMsg = (text, ctx) ->
		str = ''
		str += chars.clean
		str += chars.end
		
		if ctx?
			if text.constructor is Array
				text = text.join '\r\n'
				
			str += util.format.apply util, arguments
		else
			str += text
			
		str
	
	nyaned = (start) ->
		Math.floor((Date.now() - start) / 1e3)
		
	nyanedString = (start) ->
		text = util.format(messages.nyaned, nyaned(start) - 5)
		field = new Array(80 - text.length).join(' ')
		[chars.text, chars.draw[','], field, text, field, chars.end, chars.textEnd].join('')
	
	constructor: (@port, @fps = 12) ->
		@server = net.createServer @client
		@server.listen @port
	
	client: (con) =>
		# @clients++
		frame = 0
		start = Date.now()
		tick = off
		intro = off
		
		con.setEncoding 'binary'
		
		con.on 'end', =>
			clearInterval tick
			clearInterval intro
			# @clients--
		
		con.on 'data', (data) =>
			switch data.toString('utf8').trim()
				when 'q'
					con.write chars.clean
					con.end()
		
		con.write genMsg messages.intro, 5
		
		intro = setInterval =>	
			if nyaned(start) >= 5
				clearInterval intro
				tick = setInterval =>
					if frame is 12
						frame = 0

					con.write genMsg "#{animation[frame++]}\r\n#{nyanedString start}"
				, 1e3 / @fps
			else 
				con.write genMsg messages.intro, 5 - nyaned(start)
		, 1e3
		
		
		
module.exports = Server