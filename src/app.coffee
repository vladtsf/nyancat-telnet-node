program = require 'commander'
util = require 'util'
Server = require './server.js'
pkg = require '../package.json'
messages = require '../assets/messages.json'

program
	.version(pkg.version)
	.option('-p, --port <port>', 'telnet port', 23)
	.option('-f, --fps <rate>', 'custom fps value', 12)
	.parse(process.argv);

srv = module.exports = new Server(program.port, program.fps)

srv.server.on 'listening', () ->
	console.log util.format messages.listening, program.port, program.fps
	
process.on 'uncaughtException', (e) ->
	switch e.code
		when 'EACCES'
			console.log messages.startErr
		else
			console.log 'Oops! Something went wrong!'
		
	