.PHONY: build
build:
	dune build

.PHONY: test
test:
	$(MAKE) build
	dune runtest

.PHONY: setup
setup:
	opam install . --deps-only --with-dev-setup --with-test
