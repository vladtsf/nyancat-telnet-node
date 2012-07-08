COMPILER=$(PWD)/node_modules/coffee-script/bin/coffee --bare --output $(PWD)/lib/
NODE=$(shell which node)

all: lib assets/animation.json

lib: lib/server.js lib/frames.js

lib/%.js:
	$(COMPILER) $(PWD)/src/$(shell basename $(@) | sed -e s/.js/.coffee/)

assets/animation.json: lib/frames.js
	$(NODE) $(PWD)/lib/frames.js > $(PWD)/assets/animation.json

watch:
	$(COMPILER) --watch $(PWD)/src/

clean:
	$(RM) -r $(PWD)/lib/*.js
	$(RM) -r $(PWD)/assets/animation.json

.PHONY: all clean