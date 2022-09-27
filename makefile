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
	cp practice_github_basic/assignment.pdf assignment03.pdf
	cp practice_github_advanced/assignment.pdf assignment04.pdf

copy-pptx:
	cp vcs/fig/slide.pptx github_lec01.pptx
	cp term/fig/slide.pptx github_lec02.pptx
	cp command/fig/slide.pptx github_lec03.pptx
	cp basics/fig/slide.pptx github_lec04.pptx
	cp branch/fig/slide.pptx github_lec05.pptx
	cp remote/fig/slide.pptx github_lec06.pptx
	cp advanced/fig/slide.pptx github_lec07.pptx
	cp internals/fig/slide.pptx github_lec08.pptx
	cp practice_basic/fig/slide.pptx github_exe01.pptx
	cp practice_advanced/fig/slide.pptx github_exe02.pptx
	cp practice_github_basic/fig/slide.pptx github_exe03.pptx
	cp practice_github_advanced/fig/slide.pptx github_exe04.pptx

clean:
	rm -f $(TARGET) index.html
