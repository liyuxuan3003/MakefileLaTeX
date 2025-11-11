######## Makefile for LaTeX ########

# --------------------------------
# Project name
PROJECT?=Notebook

# Build directory
# @@@@ WARNING @@@@ 
# Excute "make clean" will simply "rm -r ${BUILD_DIR}".
# Ensure ${BUILD_DIR} is a clean directory for build without anything important.
# DO NOT try to use ${BUILD_DIR}?=. for output to current directory!
# @@@@ WARNING @@@@ 
BUILD_DIR?=build

# --------------------------------
# Compiler for LaTeX
LATEX?=latexmk
LATEX_COMPILER?=-xelatex
LATEX_FLAGS?=${LATEX_COMPILER} -synctex=1 -interaction=nonstopmode -file-line-error -output-directory=${BUILD_DIR}

# Compiler for Octave
OCTAVE?=octave-cli
OCTAVE_FLAGS?=

# Compiler for Mathematica
WOLFRAM?=wolframscript
WOLFRAM_FLAGS?=-script

# Compiler for Python
PYTHON?=python
PYTHON_FLAGS?=

# Compiler for Inkscape
INKSCAPE?=inkscape
INKSCAPE_FLAGS?=

# --------------------------------
# LaTeX source files
TEXS?=$(filter-out $(wildcard *.fig.tex),$(wildcard *.tex))

# LaTeX main
MAIN_TEX?=${PROJECT}.tex

# Figure source files for LaTeX
FIGS_TEX?=$(wildcard *.fig.tex)
# Figure source files for Octave
FIGS_OCT?=$(wildcard *.fig.m)
# Figure source files for Mathematica
FIGS_WLS?=$(wildcard *.fig.wls)
# Figure source files for Python
FIGS_PYT?=$(wildcard *.fig.py)

# LaTeX main dependence
DEPS_MAIN_TEX?=
# LaTeX figures dependence
DEPS_FIGS_TEX?=
# Octave dependence
DEPS_FIGS_OCT?=
# Mathematica dependence
DEPS_FIGS_WLS?=
# Python dependence
DEPS_FIGS_PYT?=

# --------------------------------
# LaTeX output
OUTPUT?=${BUILD_DIR}/${PROJECT}.pdf
# Figure output pdf for LaTeX
FIGS_TEX_PDF?=$(addprefix ${BUILD_DIR}/,$(FIGS_TEX:.tex=.pdf))
# Figure output pdf for Octave
FIGS_OCT_PDF?=$(addprefix ${BUILD_DIR}/,$(FIGS_OCT:.m=.pdf))
# Figure output pdf for Mathematica
FIGS_WLS_PDF?=$(addprefix ${BUILD_DIR}/,$(FIGS_WLS:.wls=.pdf))
# Figure output pdf for Python
FIGS_PYT_PDF?=$(addprefix ${BUILD_DIR}/,$(FIGS_PYT:.py=.pdf))
# Figure output pdf
FIGS_PDF?=${FIGS_TEX_PDF} ${FIGS_OCT_PDF} ${FIGS_WLS_PDF} ${FIGS_PYT_PDF}
# Figure output svg
FIGS_SVG?=$(FIGS_PDF:.pdf=.svg)
# Figure output eps
FIGS_EPS?=$(FIGS_PDF:.pdf=.eps)

# --------------------------------
# Notification at the end of the task
define NOTIFY_DONE
@echo "|========> Makefile [$@]: Done"
@echo ""
endef

# --------------------------------
# Declare phony tasks
.PHONY: default run svg eps clean figs-tex-pdf figs-oct-pdf figs-wls-pdf figs-pyt-pdf figs-pdf

# Declare not-parallel tasks (make version >= 4.4)
.NOTPARALLEL: figs-oct-pdf figs-wls-pdf svg eps

# Make LaTeX output
default: ${BUILD_DIR} ${OUTPUT}
	${NOTIFY_DONE}

# Open LaTeX output
run: default
	start ${OUTPUT}
	${NOTIFY_DONE}

# Convert all figures to svg
svg: ${FIGS_SVG}
	${NOTIFY_DONE}

# Convert all figures to eps
eps: ${FIGS_EPS}
	${NOTIFY_DONE}

# Clean build directory
clean:
	rm -r -v -I ${BUILD_DIR}
	${NOTIFY_DONE}

# Phony task for LaTeX figures
figs-tex-pdf: ${FIGS_TEX_PDF}

# Phony task for Octave figures
figs-oct-pdf: ${FIGS_OCT_PDF}

# Phony task for Mathematica figures
figs-wls-pdf: ${FIGS_WLS_PDF}

# Phony task for Python figures
figs-pyt-pdf: ${FIGS_PYT_PDF}

# Build all figures
figs-pdf: figs-tex-pdf figs-oct-pdf figs-wls-pdf figs-pyt-pdf

# --------------------------------
# Create build directory
${BUILD_DIR}:
	mkdir -p ${BUILD_DIR}
	${NOTIFY_DONE}

# Compile LaTeX main
${OUTPUT}: ${TEXS} figs-pdf ${DEPS_MAIN_TEX} 
	${LATEX} ${LATEX_FLAGS} ${MAIN_TEX}
	touch $@
	${NOTIFY_DONE}

# Compile LaTeX figure
${BUILD_DIR}/%.fig.pdf: %.fig.tex ${DEPS_FIGS_TEX}
	${LATEX} ${LATEX_FLAGS} $<
	touch $@
	${NOTIFY_DONE}

# Compile Octave figure
${BUILD_DIR}/%.fig.pdf: %.fig.m ${DEPS_FIGS_OCT}
	${OCTAVE} ${OCTAVE_FLAGS} $<
	${NOTIFY_DONE}

# Compile Mathematica figure
${BUILD_DIR}/%.fig.pdf: %.fig.wls ${DEPS_FIGS_WLS}
	${WOLFRAM} ${WOLFRAM_FLAGS} $<
	${NOTIFY_DONE}

# Compile Python figure
${BUILD_DIR}/%.fig.pdf: %.fig.py ${DEPS_FIGS_PYT}
	${PYTHON} ${PYTHON_FLAGS} $<
	${NOTIFY_DONE}

# Convert figure from pdf to svg
${BUILD_DIR}/%.fig.svg: ${BUILD_DIR}/%.fig.pdf
	${INKSCAPE} ${INKSCAPE_FLAGS} --export-filename=$@ $<

# Convert figure from pdf to eps
${BUILD_DIR}/%.fig.eps: ${BUILD_DIR}/%.fig.pdf
	${INKSCAPE} ${INKSCAPE_FLAGS} --export-filename=$@ $<