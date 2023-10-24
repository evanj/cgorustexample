//go:build darwin && arm64

// For build constraints see: https://pkg.go.dev/cmd/go#hdr-Build_constraints

package gorustmodule

// #cgo LDFLAGS: ${SRCDIR}/libexamplerustlib_darwin_arm64.a
import "C"
