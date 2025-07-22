######## Makefile for LaTeX ########

# --------------------------------
# Project Name
PROJECT=Notebook

# Build Directory
# @@@@ WARNING @@@@ 
# Excute "make clean" will simply "rm -r ${BUILD_DIR}".
# Ensure ${BUILD_DIR} is a clean directory for build without anything important.
# DO NOT try to use ${BUILD_DIR}=. for output to current directory!
# @@@@ WARNING @@@@ 
BUILD_DIR=build

# --------------------------------
# Compiler for LaTeX
LATEX=latexmk
LATEX_FLAGS=-xelatex -synctex=1 -interaction=nonstopmode -file-line-error -output-directory=${BUILD_DIR}

# Compiler for Octave
OCTAVE=octave-cli
OCTAVE_FLAGS=

# Compiler for Mathematica
WOLFRAM=wolframscript
WOLFRAM_FLAGS=-script

# Compiler for Python
PYTHON=python
PYTHON_FLAGS=

# Compiler for Inkscape
INKSCAPE=inkscape
INKSCAPE_FLAGS=

# --------------------------------
# LaTeX source files
TEXS=$(filter-out $(wildcard *.fig.tex),$(wildcard *.tex))

# LaTeX main
MAIN_TEX=${PROJECT}.tex

# Figure source files for LaTeX
FIGS_TEX=$(wildcard *.fig.tex)
# Figure source files for Octave
FIGS_OCT=$(wildcard *.fig.m)
# Figure source files for Mathematica
FIGS_WLS=$(wildcard *.fig.wls)
# Figure source files for Python
FIGS_PYT=$(wildcard *.fig.py)

# LaTeX package Minimus
STYS_MINIMUS=$(wildcard minimus/*.sty)
# LaTeX documentclass NotebookNeon
CLSS_NOTEBOOK_NEON=$(wildcard notebook-neon/*.cls)
# LaTeX documentclass BeamerBismuth
CLSS_BEAMER_BISMUTH=$(wildcard beamer-bismuth/*.cls)
# LaTeX documentclass StandaloneSilicon
CLSS_STANDALONE_SILICON=$(wildcard standalone-silicon/*.cls)

# LaTeX main dependence
DEPS_MAIN_TEX=
# LaTeX figures dependence
DEPS_FIGS_TEX=

# --------------------------------
# LaTeX output
OUTPUT=${BUILD_DIR}/${PROJECT}.pdf
# Figure output pdf for LaTeX
FIGS_TEX_PDF=$(addprefix ${BUILD_DIR}/,$(FIGS_TEX:.tex=.pdf))
# Figure output pdf for Octave
FIGS_OCT_PDF=$(addprefix ${BUILD_DIR}/,$(FIGS_OCT:.m=.pdf))
# Figure output pdf for Mathematica
FIGS_WLS_PDF=$(addprefix ${BUILD_DIR}/,$(FIGS_WLS:.wls=.pdf))
# Figure output pdf for Python
FIGS_PYT_PDF=$(addprefix ${BUILD_DIR}/,$(FIGS_PYT:.py=.pdf))
# Figure output pdf
FIGS_PDF=${FIGS_TEX_PDF} ${FIGS_OCT_PDF} ${FIGS_WLS_PDF} ${FIGS_PYT_PDF}
# Figure output svg
FIGS_SVG=$(FIGS_PDF:.pdf=.svg)
# Figure output eps
FIGS_EPS=$(FIGS_PDF:.pdf=.eps)

# --------------------------------
# Notification at the end of the task
define NOTIFY_DONE
@echo "|========> Makefile [$@]: Done"
endef

# --------------------------------
# Declare phony tasks
.PHONY: default run fig-pdf fig-svg fig-eps clean

# Declare not-parallel tasks
.NOTPARALLEL: ${FIGS_OCT_PDF} ${FIGS_WLS_PDF} ${FIGS_SVG} ${FIGS_EPS}

# Make LaTeX output
default: ${BUILD_DIR} ${OUTPUT}
	${NOTIFY_DONE}

# Open LaTeX output
run: default
	start ${OUTPUT}
	${NOTIFY_DONE}

# Make all the figures
fig-pdf: ${BUILD_DIR} ${FIGS_PDF}
	${NOTIFY_DONE}

# Convert all the figures to svg
fig-svg: ${BUILD_DIR} ${FIGS_SVG}
	${NOTIFY_DONE}

# Convert all the figures to eps
fig-eps: ${BUILD_DIR} ${FIGS_EPS}
	${NOTIFY_DONE}

# Clean build directory
clean:
	rm -r -v -I ${BUILD_DIR}
	${NOTIFY_DONE}

# --------------------------------
# Create build directory
${BUILD_DIR}:
	mkdir -p ${BUILD_DIR}
	${NOTIFY_DONE}

# Compile LaTeX main
${OUTPUT}: ${TEXS} ${FIGS_PDF} ${DEPS_MAIN_TEX}
	${LATEX} ${LATEX_FLAGS} ${MAIN_TEX}
	touch $@
	${NOTIFY_DONE}

# Compile LaTeX figure
${BUILD_DIR}/%.fig.pdf: %.fig.tex ${DEPS_FIGS_TEX}
	${LATEX} ${LATEX_FLAGS} $<
	touch $@
	${NOTIFY_DONE}

# Compile Octave figure
${BUILD_DIR}/%.fig.pdf: %.fig.m
	${OCTAVE} ${OCTAVE_FLAGS} $<
	${NOTIFY_DONE}

# Compile Mathematica figure
${BUILD_DIR}/%.fig.pdf: %.fig.wls
	${WOLFRAM} ${WOLFRAM_FLAGS} $<
	${NOTIFY_DONE}

# Compile Python figure
${BUILD_DIR}/%.fig.pdf: %.fig.py
	${PYTHON} ${PYTHON_FLAGS} $<
	${NOTIFY_DONE}

# Convert figure from pdf to svg
${BUILD_DIR}/%.fig.svg: ${BUILD_DIR}/%.fig.pdf
	${INKSCAPE} ${INKSCAPE_FLAGS} --export-filename=$@ $<

# Convert figure from pdf to eps
${BUILD_DIR}/%.fig.eps: ${BUILD_DIR}/%.fig.pdf
	${INKSCAPE} ${INKSCAPE_FLAGS} --export-filename=$@ $<