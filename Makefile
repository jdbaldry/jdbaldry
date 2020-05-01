.ONESHELL:
.DELETE_ON_ERROR:
SHELL       := bash
.SHELLFLAGS := -euf -o pipefail -c
MAKEFLAGS   += --warn-undefined-variables
MAKEFLAGS   += --no-builtin-rules

srcs  = $(shell jsonnet -Se "std.join(' ', std.objectFields(import 'quiz.jsonnet'))")
pages = $(srcs:.md=.html)

all: $(pages)

%.html: %.md
	pandoc -o $@ $<
	rm $<

%.md: quiz.jsonnet
	jsonnet -Se "(import '$<')['$@']" > $@

clean:
	rm $(pages)