package main

import (
	"github.com/gopherjs/gopherjs/js"
	rivescript "github.com/aichaos/rivescript-go"
)

func RiveScript() *js.Object {
	return js.MakeWrapper(rivescript.New())
}

func main() {
	js.Module.Set("exports", RiveScript)
}
