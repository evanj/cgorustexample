# Using Rust from Go with Cgo: Example

This repository contains:

* `examplerustlib`: A Rust library that doesn't do much
* `crustexe`: A C program that links the Rust library
* `gorustmodule`: A Go library that wraps `examplerustlib` in a Go API.
* `gorustexe`:


This should build using `make` on Linux and Mac OS X, although I may have screwed stuff up.

## Supported Rust Targets

Rust x86_64-unknown-linux-gnu = Go linux amd64


## A Brief Tutorial

* Rust: Use `#[no_mangle] pub unsafe extern "C"` on functions you want to export.
* Rust: Add `[lib] crate-type = ["lib", "staticlib"]` to `Cargo.toml`.
* Copy the resulting shared library to a directory with Go code.
* Go: Add `// #cgo LDFLAGS: ${SRCDIR}/libexamplerustlib_linux_amd64.a` to a .go file with the appropriate build tags.
