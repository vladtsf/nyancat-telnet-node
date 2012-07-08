COMPILER=$(PWD)/node_modules/coffee-script/bin/coffee --bare --output $(PWD)/lib/

all: lib

lib: lib/server.js

lib/%.js:
	$(COMPILER) $(PWD)/src/$(shell basename $(@) | sed -e s/.js/.coffee/)

watch:
	$(COMPILER) --watch $(PWD)/src/

clean:
	$(RM) -r $(PWD)/lib/*.js

.PHONY: all clean