commit:
	npx git-cz

push:
	git push origin @

.PHONY: secound
secound:
	./scripts/forzsh.sh
	./asdf/_install.sh
	./asdf/go.sh
	./asdf/python.sh
	./asdf/ruby.sh
	./asdf/rust.sh
	./asdf/nodejs.sh
	./scripts/neovim.sh

