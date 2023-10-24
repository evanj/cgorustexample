//go:build linux && amd64

// For build constraints see: https://pkg.go.dev/cmd/go#hdr-Build_constraints

package gorustmodule

// #cgo LDFLAGS: ${SRCDIR}/libexamplerustlib_linux_amd64.a
import "C"
