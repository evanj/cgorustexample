CC=clang
CFLAGS:=-Wall -Wextra -Werror
EXES:=crustexe/crustexe
RUSTLIB_HOST_PLATFORM:=examplerustlib/target/debug/libexamplerustlib.a
GOLIBS:=gorustmodule/libexamplerustlib_linux_amd64.a gorustmodule/libexamplerustlib_darwin_arm64.a

all: $(EXES) $(GOLIBS) $(RUSTLIB_HOST_PLATFORM)
	cd examplerustlib && cargo test && cargo build
	cd examplerustlib && cargo fmt
	# https://github.com/rust-lang/rust-clippy/blob/master/README.md
	cd examplerustlib && cargo clippy -- \
		--deny clippy::nursery \
		--deny clippy::pedantic \
		--allow clippy::missing-errors-doc


	clang-format -i crustexe/crustexe.c

	go test ./gorustexe ./gorustmodule
	staticcheck --checks=all ./gorustexe ./gorustmodule
	goimports -w ./gorustexe ./gorustmodule


# This is annoying to run on Mac OS X so moved to a separate target for now
clang_tidy:
	# DeprecatedOrUnsafeBufferHandling: Warns about snprintf which has no alternative in glibc
	clang-tidy \
		--checks=all,-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling \
		crustexe/crustexe.c


# Adds cross-compile targets for rustc
setup_rust_cross:
	rustup target add x86_64-unknown-linux-gnu
	rustup target add aarch64-apple-darwin

crustexe/crustexe: crustexe/crustexe.c $(RUSTLIB_HOST_PLATFORM)

$(RUSTLIB_HOST_PLATFORM): examplerustlib/src/*
	cd examplerustlib && cargo test
	cd examplerustlib && cargo fmt
	# https://github.com/rust-lang/rust-clippy/blob/master/README.md
	cd examplerustlib && cargo clippy -- \
		--deny clippy::nursery \
		--deny clippy::pedantic \
		--allow clippy::missing-errors-doc

	# build native version as well as cross-compiled versions
	cd examplerustlib && cargo build
	cd examplerustlib && cargo build --target=aarch64-apple-darwin
	cd examplerustlib && cargo build --target=x86_64-unknown-linux-gnu

	cp examplerustlib/target/x86_64-unknown-linux-gnu/debug/libexamplerustlib.a gorustmodule/libexamplerustlib_linux_amd64.a
	cp examplerustlib/target/aarch64-apple-darwin/debug/libexamplerustlib.a gorustmodule/libexamplerustlib_darwin_arm64.a

clean:
	$(RM) $(EXES) 
	$(RM) -r examplerustlib/target*
