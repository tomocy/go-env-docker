PLATFORM=local

all: bin/example

bin/example: main.go
	@docker build . \
		--target bin \
		--output bin \
		--platform ${PLATFORM}

.PHONEY: check
check: test lint

.PHONEY: test
test: main.go main_test.go
	@docker build . --target test

.PHONEY: lint
lint: main.go main_test.go
	@docker build . --target lint