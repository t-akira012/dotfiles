commit:
	npx git-cz

.PHONY: asdf
asdf:
	./asdf/go.sh
	./asdf/python.sh
	./asdf/ruby.sh
	./asdf/rust.sh
	./asdf/nodejs.sh

.PHONY: install
install:
	./scripts/_build_neovim_stable.sh
	./scripts/cica.sh
	./scripts/neovim.sh
