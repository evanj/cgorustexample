package main

import (
	"fmt"

	"github.com/evanj/cgorustexample/gorustmodule"
)

func main() {
	fmt.Println("calling gorustmodule.RustMessage() from another Go module ...")
	s, err := gorustmodule.RustMessage()
	if err != nil {
		panic(err)
	}
	fmt.Printf("  s=%#v\n", s)
}
