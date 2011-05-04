ALL: poster_landscape.pdf

%.pdf: %.tex 
	pdflatex $< &&	pdflatex $< && pdflatex $<
	open *.pdf

clean:
	  rm -f *.aux	*.bbl	*.blg	*.log	poster.pdf poster_landscape.pdf
