# RiveScript Go Bindings (RSGB)

This repo contains (experimental) bindings to the Go RiveScript module for other
programming languages.

In the cases where the programming language already has a native version of
RiveScript, consider these bindings to be fun experiments, but you should
probably prefer the native versions instead.

In this repo there is a top-level directory for each programming language.
Each one will be accompanied by its own README containing instructions on how
to build and use the module.

## Experiments

* [JavaScript via GopherJS](js/): GopherJS transpiles Go code into native JavaScript
  which pretty good performance and syscall support.
* [WebAssembly](js-wasm/): Go 1.11 supports WebAssembly binary targets. Manual
  boilerplate glue is needed to bridge the API across. Stream and Reply supported
  so far and Go and (Go)JavaScript object macro support.
