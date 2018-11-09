// +build js,wasm

package main

import (
	"fmt"
	"runtime"
	"syscall/js"

	rivescript "github.com/aichaos/rivescript-go"
	"github.com/aichaos/rivescript-go/lang/javascript"
)

var (
	bot            *rivescript.RiveScript
	beforeUnloadCh = make(chan struct{})
)

func main() {
	// alert := js.Global().Get("alert")
	// alert.Invoke(js.ValueOf("Hello world!"))

	var (
		optDebug = true // js.Global().Get("RS_Debug").Bool()
		optUTF8  = true // js.Global().Get("RS_UTF8").Bool()
	)

	bot = rivescript.New(&rivescript.Config{
		Debug: optDebug,
		UTF8:  optUTF8,
	})
	bot.SetHandler("javascript", javascript.New(bot))
	bot.SetSubroutine("test", func(rs *rivescript.RiveScript, args []string) string {
		return fmt.Sprintf("Hello from Go! Built with GOOS=%s GOARCH=%s Version=%s",
			runtime.GOOS,
			runtime.GOARCH,
			runtime.Version(),
		)
	})

	// Stream function callback.
	fnStream := js.NewCallback(func(args []js.Value) {
		var (
			code   = args[0].String()
			nextFn = args[1]
		)
		bot.Stream(code)
		nextFn.Invoke()
	})
	defer fnStream.Release()
	setStream := js.Global().Get("__streamRegistered")
	setStream.Invoke(fnStream)

	// Reply function callback.
	fnReply := js.NewCallback(func(args []js.Value) {
		var (
			username = args[0].String()
			message  = args[1].String()
			thenFn   = args[2]
		)
		bot.SortReplies()
		reply, err := bot.Reply(username, message)
		if err != nil {
			reply = "Error: " + err.Error()
		}
		thenFn.Invoke(js.ValueOf(reply))
	})
	defer fnReply.Release()
	setReply := js.Global().Get("__replyRegistered")
	setReply.Invoke(fnReply)

	fnBeforeUnload := js.NewEventCallback(0, func(event js.Value) {
		beforeUnloadCh <- struct{}{}
	})
	defer fnBeforeUnload.Release()
	addEventListener := js.Global().Get("addEventListener")
	addEventListener.Invoke("beforeunload", fnBeforeUnload)

	<-beforeUnloadCh
	fmt.Println("Bye wasm!")
}
