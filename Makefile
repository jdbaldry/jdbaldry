.ONESHELL:
.DELETE_ON_ERROR:
SHELL       := bash
.SHELLFLAGS := -euf -o pipefail -c
MAKEFLAGS   += --warn-undefined-variables
MAKEFLAGS   += --no-builtin-rule

index.html: index.md
	pandoc -s -i --slide-level 3 -t revealjs -V simple -V revealjs-url=https://revealjs.com -o $@ $<
