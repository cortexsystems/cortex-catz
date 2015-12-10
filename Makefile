lint:
	./node_modules/.bin/coffeelint src

dist:
	gulp pack

clean:
	rm -rf ./build ./dist

.PHONY: doc
