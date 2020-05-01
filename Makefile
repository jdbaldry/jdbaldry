srcs = index.html $(wildcard questions/*.md)
pages = $(srcs:.md=.html)

all: $(pages)

%.html: %.md
	pandoc -o $@ $<


