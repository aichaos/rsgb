# RSGB for JavaScript

This is a "binding" of the RiveScript Go module to JavaScript. It's compiled
using [gopherjs](https://github.com/gopherjs/gopherjs).

I learned how to do this from the [bluemonday-js](https://github.com/mdp/bluemonday-js/blob/master/README.md#turning-golang-code-into-an-npm-module-with-gopherjs)
project on GitHub. See their README for the background of how this works.

This module should be available via npm if you're brave enough to try it:

`npm install rivescript-rsgb`

For production use you should be better off using the native JavaScript
implementation of RiveScript at <https://github.com/aichaos/rivescript-js>.

# API Differences

There are a couple of differences in the API to this module versus the native
JavaScript version of RiveScript. Refer to the
[GoDoc](https://godoc.org/github.com/aichaos/rivescript-go) for the RiveScript
Go module for API usage. Briefly, most of the functions you're used to now
begin with a capital letter, as that's the convention for exported functions in
Go. For example, `SetUservar()` rather than `setUservar()`.

Also, only the exported *functions* of the RiveScript Go module are available to
JavaScript, so you e.g. can't assign `bot.Debug = true` to turn on debug mode.
Instead, use the following functions to configure the bot:

```javascript
var bot = new RiveScript(); // The constructor takes no parameters
bot.SetDebug(true);  // Activate debug mode
bot.SetUTF8(true);    // Enable UTF-8 support
bot.SetDepth(100);   // Change recursion depth
bot.SetStrict(true); // Strict syntax parsing (it's true by default)

// To override the Unicode punctuation symbols call this function and pass it
// the *string literal* regexp (not a Regexp object; these don't translate well
// into Go)
bot.SetUnicodePunctuation('[.,!?;:]')
```

# Usage

```javascript
var RiveScript = require("rivescript-rsgb"),
    fs = require("fs");

var bot = new RiveScript();

// No system calls are supported for gopherjs so LoadDirectory/LoadFile won't
// work... we have to use Stream() to input all the RiveScript documents.
bot.Stream(fs.readFileSync("rs-standard.rive", "utf8"));
bot.SortReplies();

var username = "local-user";
var reply = bot.Reply(username, "hello, bot");
console.log("Bot>", reply);
```

# Building

These steps assume you already have a working Golang development environment.

First, install gopherjs and the source to rivescript-go:

```bash
$ go get -u github.com/gopherjs/gopherjs
$ go get github.com/aichaos/rivescript-go
```

Grunt commands (needs `grunt-cli`, e.g. `npm install -g grunt-cli`):

* `grunt test`: Run the unit tests
* `grunt dist`: Browserify and minify the JavaScript. This should make the
  module available to be served on a web page. The output goes into the `dist/`
  directory.
* `grunt clean`: Removes the `dist/` directory.

# Caveats

System calls aren't supported by gopherjs, so the RiveScript module can't access
files from disk. This means `LoadFile()` and `LoadDirectory()` calls will fail.
The alternative is for your JavaScript to load the files on its own, and pass
their contents in via `Stream()`.

Object macros aren't supported at this time but may be investigated in the
future.

The file sizes of the compiled JavaScript files are substantially larger than
the native JS version (at time of writing we're talking 1.8M versus 64K!).
Minified it's 900KB larger than the native JavaScript version.

# LICENSE

```
The MIT License (MIT)

Copyright (c) 2015 Noah Petherbridge

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

# SEE ALSO

The official RiveScript website, <http://www.rivescript.com/>

The native JavaScript port of RiveScript,
<https://github.com/aichaos/rivescript-js>
