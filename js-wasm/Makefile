all: build

.PHONY: build
build:
	GOOS=js GOARCH=wasm go build -o rivescript.wasm

.PHONY: run
run: build
	go run httpserver/main.go
