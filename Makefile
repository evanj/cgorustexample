CC=clang
CFLAGS:=-Wall -Wextra -Werror
EXES:=crustexe/crustexe
RUSTLIB:=examplerustlib/target/debug/libexamplerustlib.a
GOLIBS:=gorustmodule/libexamplerustlib_linux_amd64.a

all: $(EXES) $(GOLIBS)
	cd examplerustlib && cargo test && cargo build
	cd examplerustlib && cargo fmt
	# https://github.com/rust-lang/rust-clippy/blob/master/README.md
	cd examplerustlib && cargo clippy -- \
		--deny clippy::nursery \
		--deny clippy::pedantic \
		--allow clippy::missing-errors-doc

	# DeprecatedOrUnsafeBufferHandling: Warns about snprintf which has no alternative in glibc
	clang-tidy \
		--checks=all,-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling \
		crustexe/crustexe.c
	clang-format -i crustexe/crustexe.c

crustexe/crustexe: crustexe/crustexe.c $(RUSTLIB)

$(RUSTLIB): examplerustlib/src/*
	cd examplerustlib && cargo test
	cd examplerustlib && cargo fmt
	# https://github.com/rust-lang/rust-clippy/blob/master/README.md
	cd examplerustlib && cargo clippy -- \
		--deny clippy::nursery \
		--deny clippy::pedantic \
		--allow clippy::missing-errors-doc

	cd examplerustlib && cargo build

gorustmodule/libexamplerustlib_linux_amd64.a: $(RUSTLIB)
	cp $^ $@

clean:
	$(RM) $(EXES) $(RUSTLIB)
