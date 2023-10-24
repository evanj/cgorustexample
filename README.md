# Using Rust from Go with Cgo: Example

This repository contains:

* `examplerustlib`: A Rust library that doesn't do much
* `crustexe`: A C program that links the Rust library
* `gorustmodule`: A Go library that wraps `examplerustlib` in a Go API.
* `gorustexe`:


This should build using `make` on Linux and Mac OS X, although I may have screwed stuff up.
