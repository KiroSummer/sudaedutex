thesis: tableofcontents
	bibtex thesis
	xelatex thesis

tableofcontents:
	xelatex thesis

count:
	texcount.pl -ch-only -merge thesis.tex

clean:
	rm -f *.log
	rm -f *.toc
	rm -f *.gz
	rm -f *.aux
	rm -f *.out
	rm -f *.bbl
	rm -f *.blg
	rm -f sections/*.rel

