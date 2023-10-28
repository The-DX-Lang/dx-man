V_EXECUTABLE = v

NODEMON_EXECUTABLE = npx nodemon

.PHONY: clear
clear:
	@cls || clear

.PHONY: run
run:
	${V_EXECUTABLE} run ./src/main.v

.PHONY: watch
watch:
	${NODEMON_EXECUTABLE} -w src -e v -x "make clear run || exit 1"

.PHONY: build-debug
build-debug:
	${V_EXECUTABLE} build -g -o ./dx-man

.PHONY: build
build:
	${V_EXECUTABLE} build -o ./dx-man
