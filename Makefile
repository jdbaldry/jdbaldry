.ONESHELL:
.DELETE_ON_ERROR:
SHELL       := bash
.SHELLFLAGS := -euf -o pipefail -c
MAKEFLAGS   += --warn-undefined-variables
MAKEFLAGS   += --no-builtin-rule

all: index.html

%.html: %.md
	pandoc -s -i --slide-level 3 -t revealjs -V theme=blood -V simple -V revealjs-url=https://revealjs.com -o $@ $<

%.md: quiz.jsonnet
	jsonnet -Se "(import '$<')['$@']" > $@
