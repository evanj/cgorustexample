all:
	cd examplerustlib && cargo test
	cd examplerustlib && cargo fmt
	# https://github.com/rust-lang/rust-clippy/blob/master/README.md
	cd examplerustlib && cargo clippy -- \
		--deny clippy::nursery \
		--deny clippy::pedantic \
		--allow clippy::missing-errors-doc
