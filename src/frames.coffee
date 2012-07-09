source = require '../assets/frames'
chars = require('../assets/characters')
draw = chars.draw

frames = []
exps = {}

for frame, frIdx in source
	for line, lIdx in frame
		newLine = []
		
		for char, idx in line
			if idx is 0
				newLine.push draw[char]
				newLine.push chars.point
			else if char isnt line[idx - 1]
				newLine.push chars.end
				newLine.push draw[char]
				newLine.push chars.point
			else
				newLine.push chars.point
				
			if idx is (line.length - 1)	
				newLine.push chars.end
		
		frame[lIdx] = newLine.join ''
	source[frIdx] = frame.join('\r\n')
			
console.log JSON.stringify source

