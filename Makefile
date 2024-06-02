# $Id: Makefile 7134 2017-11-15 01:02:55Z cfrees $
SHELL=/bin/sh
PATH=/usr/local/bin:/usr/local/texlive/bin:/usr/bin
TEXMFHOME=

dirintro := gweithdy-latex-da-1
dirmacros := gweithdy-latex-da-2-macros
dirbiblatex := gweithdy-latex-da-2-biblatex
dirbeamer := gweithdy-latex-da-2-beamer
dirpellach := gweithdy-latex-da-2-pellach
dirhandoutsadd := handouts
dirconfig := config
dirwrappers := wrappers

# do NOT add idx!!
exts := aux auxlock bbl bcf blg ilg ind lof log lot glg glo gls mw nav out snm run.xml synctex.gz backup bkup toc xdy for aux.copy mw.mw mmz mmz.log acn acr alg ent hd vrb 

config := $(dirconfig)/handouts-da.cfg $(dirconfig)/macros-da.cfg $(dirconfig)/beamer-da.cfg $(dirconfig)/example-overleaf.tex
wrappers := $(dirwrappers)/handouts.tex $(dirwrappers)/slides.tex $(dirwrappers)/tutornotes.tex

handoutsadd := $(dirhandoutsadd)/latex-gweithdy-font-sampler.pdf $(dirhandoutsadd)/latex-gweithdy-fonts.pdf $(dirhandoutsadd)/latex-gweithdy-packages.pdf

pdfscore := handouts.pdf tutornotes.pdf slides.pdf
dirscore := $(dirintro) $(dirmacros) $(dirbiblatex) $(dirbeamer) $(dirpellach)

pdfsintro := $(addprefix $(dirintro)/,$(pdfscore))
pdfsmacros := $(addprefix $(dirmacros)/,$(pdfscore)) $(handoutsadd)
pdfsbiblatex := $(addprefix $(dirbiblatex)/,$(pdfscore)) 
pdfsbeamer := $(addprefix $(dirbeamer)/,$(pdfscore)) 
pdfspellach := $(addprefix $(dirpellach)/,$(pdfscore)) 

handouts := $(addsuffix /handouts.pdf,$(dirscore)) $(handoutsadd)
tutornotes := $(addsuffix /tutornotes.pdf,$(dirscore))
slides := $(addsuffix /slides.pdf,$(dirscore))

texeeintro := $(addprefix $(dirintro)/examples/,example1.tex example2.tex example3.tex example4.tex example5.tex example6.tex example7.tex example8.tex example9.tex)
pdfeeintro :=
bibeeintro := $(addprefix $(dirintro)/examples/,myrefs.bib)
handsintro := $(addprefix $(dirintro)/handouts/,handouts.pdf winston-latexsheet-a4.pdf carlisle-maths.pdf leaflet.pdf)

texeemacros := $(addprefix $(dirmacros)/examples/,example10.tex)
pdfeemacros =
eemacros := $(texeemacros) $(pdfeemacros)
handsmacros := $(addprefix $(dirmacros)/handouts/,handouts.pdf latex-gweithdy-fonts.pdf latex-gweithdy-font-sampler.pdf latex-gweithdy-packages.pdf winston-latexsheet-a4.pdf)

texeebiblatex := $(addprefix $(dirbiblatex)/examples/,example12.tex example11.tex example11-1.tex example11-2.tex example12-1.tex example12-2.tex)
pdfeebiblatex := $(addprefix $(dirbiblatex)/examples/,example11-1.pdf example11-2.pdf example12-1.pdf example12-2.pdf)
bibeebiblatex := $(addprefix $(dirbiblatex)/examples/,myrefs.bib myrefs-add.bib)
eebiblatex := $(texeebiblatex) $(pdfeebiblatex) $(bibeebiblatex)
handsbiblatex := $(addprefix $(dirbiblatex)/handouts/,handouts.pdf biblatex-cheatsheet.pdf) 

texeebeamer := $(addprefix $(dirbeamer)/examples/,example13.tex example14.tex example15.tex)
pdfeebeamer := $(subst .tex,.pdf,$(texeebeamer))
eebeamer := $(texeebeamer) $(pdfeebeamer)
handsbeamer := $(addprefix $(dirbeamer)/handouts/,handouts.pdf) 

pdfeepellach := $(addprefix $(dirpellach)/examples/,example16.pdf example16-mod.pdf pgfplots-sin.pdf tikz-siml.pdf)
texeepellach := $(subst .pdf,.tex,$(texeepellach)) $(add prefix $(dirpellach)/examples/,tikz-annotated-cuboid.tex tikz-automata-finite-state-transducer.tex tikz-cd-eg.tex tikz-shaded-delaunay-pattern.tex tikz-ticking-timers.tex)
eepellach := $(texeepellach) $(pdfeepellach) $(dirpellach)/examples/pgfplotsexample.pdf $(dirpellach)/examples/pgfplotsexample.tex
handspellach := $(addprefix $(dirpellach)/handouts/,handouts.pdf) 

pdfs := $(pdfsintro) $(pdfsmacros) $(pdfsbiblatex) $(pdfsbeamer) $(pdfspellach)
collhandouts := $(handsintro) $(handsmacros) $(handsbiblatex) $(handsbeamer) $(handspellach)

# targets (first is default)
all : $(pdfs)
.PHONY : all
gweithdai : $(pdfs) $(collhandouts) 
.PHONY : gweithdai
intro : $(pdfsintro) $(handoutsadd) $(handsintro)
.PHONY : intro
macros : $(pdfsmacros) $(handoutsadd) $(handsmacros)
.PHONY : macros
biblatex : $(pdfsbiblatex) $(handoutsadd) $(handsbiblatex)
.PHONY : biblatex
beamer : $(pdfsbeamer) $(handsbeamer) 
.PHONY : beamer
pellach : $(pdfspellach) $(handspellach)
.PHONY : pellach
floats : $(pdfspellach) $(handspellach)
.PHONY : floats
data : $(pdfspellach) $(handspellach)
.PHONY : data

# function: arara-pdf: run arara and biber, if needed
define arara-pdf =
cd $(dir $@) && (i=$(basename $(notdir $@)) ; arara $$i && ((if [ -f "$$i.bcf" ]; then biber $$i; fi) && arara $$i) ; arara $$i)
endef

# function: ee-pdf: as above, but use pdflatex to keep sources clean
define ee-pdf =
cd $(dir $@) && (i=$(basename $(notdir $@)) ; pdflatex $$i && ((if [ -f "$$i.bcf" ]; then biber $$i; fi) && pdflatex $$i) ; pdflatex $$i)
endef

# function: rm-if: remove if found
# this is idiotic
define rm-if =
(g= ; for i in $(exts) ; do rm $$(find . -path *.$$i) 2> /dev/null || g="$$g $$i" ; done; printf %b "Nothing to do for $$g")
endef

# $< is the first prerequisite

$(dirhandoutsadd)/%.pdf : $(dirhandoutsadd)/%.tex $(dirhandoutsadd)/config $(config)
	$(arara-pdf)

# ee

$(dirintro)/ee : $(eeintro) 
	cd $(dirintro) && touch ee

$(dirmacros)/ee : $(eemacros) 
	cd $(dirmacros) && touch ee

$(dirbiblatex)/ee : $(eebiblatex)
	cd $(dirbiblatex) && touch ee

$(dirbiblatex)/examples/%.pdf : $(bibeebiblatex) $(texeebiblatex)
	$(ee-pdf)

$(dirbeamer)/ee : $(eebeamer)
	cd $(dirbeamer) && touch ee

$(dirbeamer)/examples/%.pdf : $(dirbeamer)/examples/%.tex
	$(ee-pdf)

$(dirpellach)/ee : $(eepellach)
	cd $(dirpellach) && touch ee

$(dirpellach)/examples/%.pdf : $(dirpellach)/examples/%.tex
	$(ee-pdf)

# sym links for wrappers (handouts.tex, tutornotes.tex, slides.tex)

gweithdy-%/handouts.tex : | $(wrappers)
	cd $(dir $@) && ln -s ../$(dirwrappers)/handouts.tex ./

gweithdy-%/tutornotes.tex : | $(wrappers)
	cd $(dir $@) && ln -s ../$(dirwrappers)/tutornotes.tex ./

gweithdy-%/slides.tex : | $(wrappers)
	cd $(dir $@) && ln -s ../$(dirwrappers)/slides.tex ./

# core pdfs (handouts.pdf, slides.pdf, tutornotes.pdf)

gweithdy-%/slides.pdf : wrappers/slides.tex $(config) gweithdy-%/training.tex gweithdy-%/handouts.aux gweithdy-%/ee | gweithdy-%/slides.tex gweithdy-%/handouts.tex gweithdy-%/config  gweithdy-%/ffigurau
	$(arara-pdf)

gweithdy-%/handouts.aux : wrappers/handouts.tex gweithdy-%/training.tex $(config) gweithdy-%/ee | gweithdy-%/handouts.tex gweithdy-%/config gweithdy-%/ffigurau
	$(arara-pdf)

gweithdy-%/handouts.pdf : wrappers/handouts.tex $(config) gweithdy-%/training.tex gweithdy-%/ee | gweithdy-%/handouts.tex gweithdy-%/config gweithdy-%/ffigurau
	$(arara-pdf)

gweithdy-%/tutornotes.pdf : wrappers/tutornotes.tex $(config) gweithdy-%/training.tex gweithdy-%/ee | gweithdy-%/tutornotes.tex gweithdy-%/handouts.tex gweithdy-%/config gweithdy-%/ffigurau
	$(arara-pdf)

# sym link to config
%/config : | $(config)
	cd $(dir $@) && ln -s ../config ./

# for externalisation of diagrams in some workshops
gweithdy-%/ffigurau : gweithdy-%/ 
	mkdir -p $(dir $@)/ffigurau

gweithdy-%/handouts/handouts.pdf : | gweithdy-%/handouts.pdf
	mkdir -p gweithdy-%/handouts
	cd gweithdy-%/handouts && ln -s ../handouts.pdf ./

$(dirmacros)/handouts/latex-gweithdy-%.pdf : | $(dirhandoutsadd)/latex-gweithdy-%.pdf
	mkdir -p $(dirmacros)/handouts
	cd $(dirmacros)/handouts && ln -s ../../handouts/latex-gweithdy-%.pdf ./

# $(dirmacros)/handouts/winston-latexsheet-a4.pdf : | $(dirhandoutsadd)/$(notdir $@)
$(dirmacros)/handouts/winston-latexsheet.pdf : | $(dirhandoutsadd)/$(notdir $@)
	mkdir -p $(dirmacros)/handouts
	cd $(dirmacros)/handouts && ln -s ../../handouts/$(notdir $@) ./

$(dirintro)/handouts/carlisle-maths.pdf : | $(dirhandoutsadd)/$(notdir $@)
	mkdir -p $(dirintro)/handouts
	cd $(dirintro)/handouts && ln -s ../../handouts/$(notdir $@) ./

# $(dirintro)/handouts/winston-latexsheet-a4.pdf : | $(dirhandoutsadd)/$(notdir $@)
$(dirintro)/handouts/winston-latexsheet.pdf : | $(dirhandoutsadd)/$(notdir $@)
	mkdir -p $(dirintro)/handouts
	cd $(dirintro)/handouts && ln -s ../../handouts/$(notdir $@) ./

$(dirintro)/handouts/leaflet.pdf : | $(dirhandoutsadd)/$(notdir $@)
	mkdir -p $(dirintro)/handouts
	cd $(dirintro)/handouts && ln -s ../../handouts/$(notdir $@) ./

$(dirbiblatex)/handouts/biblatex-cheatsheet.pdf : | $(dirhandoutsadd)/$(notdir $@)
	mkdir -p $(dirbiblatex)/handouts
	cd $(dirbiblatex)/handouts && ln -s ../../handouts/$(notdir $@) ./

# extra handouts

$(dirhandoutsadd)/carlisle-maths.pdf :
	cd $(dirhandoutsadd) && ln -s  $(shell kpsewhich -var-value=TEXMFHOME)/doc/latex/carlisle-maths/carlisle-maths.pdf ./

$(dirhandoutsadd)/winston-latexsheet.pdf :
	cd $(dirhandoutsadd) && ln -s  $(shell kpsewhich -var-value=TEXMFDIST)/doc/latex/latexcheat/latexsheet.pdf ./$(notdir $@)

$(dirhandoutsadd)/biblatex-cheatsheet.pdf :
	cd $(dirhandoutsadd) && ln -s  $(shell kpsewhich -var-value=TEXMFDIST)/doc/latex/biblatex-cheatsheet/biblatex-cheatsheet.pdf ./

$(dirhandoutsadd)/leaflet.pdf :
	cd $(dirhandoutsadd) && ln -s  $(shell kpsewhich -var-value=TEXMFDIST)/doc/latex/leaflet/leaflet.pdf ./

# extra examples

$(dirpellach)/examples/pgfplotsexample.pdf : | $(dirpellach)/examples/
	cd $(dirpellach)/examples && ln -s  $(shell kpsewhich -var-value=TEXMFDIST)/doc/latex/pgfplots/pgfplotsexample.pdf ./

$(dirpellach)/examples/pgfplotsexample.tex : | $(dirpellach)/examples/
	cd $(dirpellach)/examples && ln -s  $(shell kpsewhich -var-value=TEXMFDIST)/doc/latex/pgfplots/pgfplotsexample.tex ./


# prevent auto removal of targets created only as intermediates 
.SECONDDARY: %.tex

.PHONY : clean
clean :
	$(rm-if)


# vim: set nospell:
