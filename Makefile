V_EXECUTABLE = v

NODEMON_EXECUTABLE = npx nodemon
NODEMON_BASE_COMMAND = ${NODEMON_EXECUTABLE} -w src -e v

.PHONY: clean
clean:
	rm -f ./dx-man

.PHONY: clear
clear:
	@cls || clear

.PHONY: run
run:
	${V_EXECUTABLE} run ./src/main.v

.PHONY: watch
watch:
	${NODEMON_BASE_COMMAND} -x "make clear run || exit 1"

.PHONY: build-debug
build-debug:
	${V_EXECUTABLE} . -g -o ./dx-man

.PHONY: build
build:
	${V_EXECUTABLE} . -o ./dx-man

.PHONY: test
test:
	v  test ./src/

.PHONY: watch-test
watch-test:
	${NODEMON_BASE_COMMAND} -x "make clear test || exit 1"
