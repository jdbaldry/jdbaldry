.ONESHELL:
.DELETE_ON_ERROR:
SHELL       := bash
.SHELLFLAGS := -euf -o pipefail -c
MAKEFLAGS   += --warn-undefined-variables
MAKEFLAGS   += --no-builtin-rule

srcs  = $(shell jsonnet -Se "std.join(' ', std.objectFields(import 'quiz.jsonnet'))")
pages = $(srcs:.md=.html)

all: $(pages)

# index.html: index.md
# 	pandoc -s --css "https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" -o $@ $<
# 	rm $<

%.html: %.md
	pandoc -s -i --slide-level 3 -t revealjs -V simple -V revealjs-url=https://revealjs.com -o $@ $<

%.md: quiz.jsonnet
	jsonnet -Se "(import '$<')['$@']" > $@

clean:
	rm $(pages)