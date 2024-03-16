commit:
	npx git-cz

push:
	git push origin @

.PHONY: secound
secound:
	./scripts/forzsh.sh
	./asdf/_install.sh
	./scripts/neovim.sh

