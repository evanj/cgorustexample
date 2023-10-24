package gorustmodule

import (
	"strings"
	"testing"
)

func TestRustMessage(t *testing.T) {
	s, err := RustMessage()
	if err != nil {
		t.Fatal(err)
	}
	if !strings.HasPrefix(s, "Hello from Rust!") {
		t.Errorf("unexpected s=%#v", s)
	}
}
