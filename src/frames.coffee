source = require '../assets/frames'
chars = require('../assets/characters')
draw = chars.draw

replacement = []
replacement.push "\\#{key}+" for key, char of draw
expr = new RegExp "(#{replacement.join('|')})", ['g']

frames = []
exps = {}

for frame, frIdx in source
	for line, lIdx in frame
		frame[lIdx] = line.replace expr, (matched) -> 
		 	draw[matched[0]] + (new Array(matched.length + 1).join(chars.point)) + chars.end
	source[frIdx] = frame.join('\r\n')
			
console.log JSON.stringify source

