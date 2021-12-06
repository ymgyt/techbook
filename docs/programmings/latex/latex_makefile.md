# Latex Makefile

```makefile
LATEX = platex
PDF = dvipdfmx

application.pdf: application.dvi
$(PDF) application

application.dvi: application.tex
$(LATEX) $<
```
