HTML=$(shell ls */README.md | sed 's/README.md/index.html/')
HTML+=index.html
PANDOC_HTMLOPT=--mathjax -t html
PANDOC_TEXOPT=--highlight-style tango --pdf-engine=lualatex -V documentclass=ltjarticle -V geometry:margin=1in -H ../mytemplate.tex
TARGET=$(HTML)
ASSIGNMENT=$(shell ls practice*/README.md | sed 's/README.md/assignment.pdf/')

all: $(HTML)

pdf: $(ASSIGNMENT)

clean-pdf:
	rm -f $(ASSIGNMENT)

%/assignment.pdf: %/README.md
	cd $(dir $@);pandoc $(notdir $<) -s -o $(notdir $@) $(PANDOC_TEXOPT)

index.md: README.md
	sed 's/README.md/index.html/' $< > $@

index.html: index.md
	pandoc -s $< -o $@ $(PANDOC_HTMLOPT) --template=template --metadata pagetitle="$<"
	rm -f index.md 

%/index.html: %/README.md
	pandoc -s $< -o $@ $(PANDOC_HTMLOPT) --template=template --metadata pagetitle="$<"

copy-pdf: $(ASSIGNMENT)
	cp practice_basic/assignment.pdf assignment01.pdf
	cp practice_advanced/assignment.pdf assignment02.pdf
	cp practice_github/assignment.pdf assignment03.pdf
	cp practice_github2/assignment.pdf assignment04.pdf

clean:
	rm -f $(TARGET) index.html
