#!/usr/bin/env bash

echo === Install Go

if which go >>/dev/null 2>&1 ;then
  echo "Go already installed."
else
  brew install go \
    && go version
fi

echo === Install Go packages
brew install fzf
go install golang.org/x/tools/cmd/gofmt@latest
go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/gopls@latest

go install github.com/x-motemen/ghq@latest
go install github.com/google/yamlfmt/cmd/yamlfmt@latest
