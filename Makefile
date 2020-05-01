pages = 01-dingbats.html

all: $(pages)

%.html: %.md
	pandoc -o $@ $<


