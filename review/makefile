TARGET=github.pdf
RE=preface.re postface.re vcs.re term.re command.re basics.re branch.re remote.re advanced.re internals.re practice_basic.re practice_advanced.re practice_github_basic.re practice_github_advanced.re references.re

all: $(TARGET)

imgcopy:
	mkdir -p images/vcs;cp ../vcs/fig/*.png images/vcs
	mkdir -p images/term;cp ../term/fig/*.png images/term
	mkdir -p images/command;cp ../command/fig/*.png images/command

%.re: ../%/README.md
	cp $< $@
	mkdir -p images/$*;cp ../$*/fig/*.png images/$*
	md2review $< > $@

$(TARGET): config.yml $(RE)
	docker run --rm -v `pwd`/:/work kauplan/review2.5 /bin/bash -c "cd /work; rake pdf"

clean:
	rm -f $(TARGET) -f $(RE)
