${HOME}/.cargo/bin/cargo-fmt:
	cargo install rustfmt --vers 0.8.3

${HOME}/.cargo/bin/cargo-tree:
	cargo install cargo-tree

tree: ${HOME}/.cargo/bin/cargo-tree
	PATH=${HOME}/.cargo/bin:${PATH} cargo tree

fmt: ${HOME}/.cargo/bin/cargo-fmt
	PATH=${HOME}/.cargo/bin:${PATH} cargo fmt

travis_fmt:
	rustup run stable cargo install rustfmt --vers 0.8.3 --force
	cargo fmt -- --write-mode=diff

build:
	RUSTFLAGS='-D warnings' cargo build

test:
	RUSTFLAGS='-D warnings' RUST_BACKTRACE=1 cargo test -- --skip sudo_ --skip loop_

sudo_test:
	sudo env "PATH=${PATH}" RUSTFLAGS='-D warnings' RUST_BACKTRACE=1 RUST_TEST_THREADS=1 cargo test

clippy:
	RUSTFLAGS='-D warnings' cargo build --features "clippy"

uml-graphs: ${HOME}/.cargo/bin/cargo-script
	PATH=${HOME}/.cargo/bin:${PATH} cargo script scripts/uml_graphs.rs

.PHONY:
	build
	clippy
	fmt
	sudo_test
	test
	travis_fmt
	tree
