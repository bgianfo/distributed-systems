LATEX=pdflatex
BIBTEX=bibtex
CONVERT_DVI=dvipdf
UNAME=$(shell uname)

# Try to find an appropriate PDF reader
ifeq ("$(UNAME)","Darwin") 
  VIEWER=open
else ifeq ("$(ARCH)","SunOS")
  VIEWER=acroread
else
  VIEWER=evince
endif

default: clean paper paper-clean

open:
	$(VIEWER) paper.pdf

build-paper: paper.tex
	$(LATEX)  paper
	$(BIBTEX) paper
	$(BIBTEX) paper
	$(LATEX)  paper
	$(LATEX)  paper

paper: build-paper open

paper-clean:
	rm -f paper.dvi
	rm -f paper.aux
	rm -f paper.log
	rm -f paper.toc
	rm -rf paper.bbl
	rm -rf paper.blg
	rm -rf missfont.log

# Check style:
proof:
	@echo ""
	@echo "Weasel words: "
	@../bin/weasel *.tex
	@echo ""
	@echo "Duplicates: "
	@../bin/dups *.tex
	@echo ""
	@echo "Passive voice: "
	@../bin/passive *.tex

detex:
	@detex paper.tex > .detex


diction: detex
	diction -L en -b -s .detex | fmt

style: detex
	style -n -N .detex | fmt

rmdetex: style diction
	@rm .detex

spell:
	aspell check -t paper.tex

clean: paper-clean
	rm -rf paper.pdf
