# MakefileLaTeX

MakefileLaTeX提供了一个适用于LaTeX项目的构建系统，以Git子模块方式引入。

MakefileLaTeX的编译基于`latexmk`，支持多种类型的图片联合编译（TikZ/Octave/Mathematica/Python/Inkscape）。

MakefileLaTeX是LumosLaTeX计划的一部分：https://github.com/liyuxuan3003/LumosLaTeX

## 文件组成

| 文件 | 说明 |
|------|------|
| `makefile-latex.mk` | 适用LaTeX的`Makefile` |
| `latex-std-dependence.mk` | 声明Lumos计划的标准子模块路径 |

## 引入方式

MakefileLaTeX以Git子模块的形式引入项目

```bash
git submodule add git@github.com:liyuxuan3003/MakefileLaTeX.git makefile-latex
```

目录结构假设

```
./
├── Makefile
├── MyProject.tex
└── makefile-latex/
```

在项目根目录的主`Makefile`中

```makefile
PROJECT:=MyProject

include makefile-latex/makefile-latex.mk
```

### 编译器修改

根据需求调整编译器设置。例如指定主文档用`pdf`编译器、图件用`xelatex`：

```makefile
LATEX_MAIN_COMPILER:=-pdf
LATEX_FIGS_COMPILER:=-xelatex
```

### 依赖项修改

以NotebookNeon和Minimus为例，导入标准依赖文件并添加项目特定的编译依赖：

```makefile
include makefile-latex/latex-std-dependence.mk

DEPS_MAIN_TEX:=${STYS_MINIMUS} ${CLSS_NOTEBOOK_NEON}
DEPS_FIGS_TEX:=${STYS_MINIMUS} ${CLSS_STANDALONE_SILICON}

include makefile-latex/makefile-latex.mk
```

`latex-std-dependence.mk`中定义了以下标准子模块路径变量：

| 变量 | 通配路径 |
|------|----------|
| `STYS_MINIMUS` | `minimus/*.sty` |
| `CLSS_NOTEBOOK_NEON` | `notebook-neon/*.cls` |
| `CLSS_ARTICLE_ARGON` | `article-argon/*.cls` |
| `CLSS_BEAMER_BISMUTH` | `beamer-bismuth/*.cls` |
| `CLSS_STANDALONE_SILICON` | `standalone-silicon/*.cls` |
| `CLSS_SI200_MINI_REVIEW` | `si200-mini-review/*.cls` |
| `CLSS_IEEE_TRAN` | `ieee-tran/*.cls` |
| `PYTS_PYJOOL` | `pyjool/*.py` |

## 变量

### 项目配置

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `PROJECT` | `Notebook` | 项目名，主文件为`${PROJECT}.tex` |
| `BUILD_DIR` | `build` | 构建输出目录，`make clean`将删除该目录 |

### 编译器

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `LATEX` | `latexmk` | LaTeX编译器 |
| `LATEX_MAIN_COMPILER` | `-xelatex` | 主文档编译器选项 |
| `LATEX_FIGS_COMPILER` | `-xelatex` | 图件编译器选项 |
| `LATEX_MAIN_FLAGS` | `${LATEX_MAIN_COMPILER} -synctex=1 -interaction=nonstopmode -file-line-error -output-directory=${BUILD_DIR}` | 主文档编译参数 |
| `LATEX_FIGS_FLAGS` | `${LATEX_FIGS_COMPILER} -synctex=1 -interaction=nonstopmode -file-line-error -output-directory=${BUILD_DIR}` | 图件编译参数 |
| `OCTAVE` | `octave-cli` | Octave解释器 |
| `OCTAVE_FLAGS` | （空） | Octave编译参数 |
| `WOLFRAM` | `wolframscript` | Mathematica解释器 |
| `WOLFRAM_FLAGS` | `-script` | Mathematica编译参数 |
| `PYTHON` | `python` | Python解释器 |
| `PYTHON_FLAGS` | （空） | Python编译参数 |
| `INKSCAPE` | `inkscape` | Inkscape矢量转换器 |
| `INKSCAPE_FLAGS` | （空） | Inkscape编译参数 |

### 源文件

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `TEXS` | `$(filter-out $(wildcard *.fig.tex),$(wildcard *.tex))` | 全部LaTeX源文件（排除图件） |
| `MAIN_TEX` | `${PROJECT}.tex` | 主LaTeX文件 |
| `FIGS_TEX` | `$(wildcard *.fig.tex)` | LaTeX图件源文件 |
| `FIGS_OCT` | `$(wildcard *.fig.m)` | Octave图件源文件 |
| `FIGS_WLS` | `$(wildcard *.fig.wls)` | Mathematica图件源文件 |
| `FIGS_PYT` | `$(wildcard *.fig.py)` | Python图件源文件 |

### 依赖

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `DEPS_MAIN_TEX` | （空） | 主文档额外依赖 |
| `DEPS_FIGS_TEX` | （空） | LaTeX图件额外依赖 |
| `DEPS_FIGS_OCT` | （空） | Octave图件额外依赖 |
| `DEPS_FIGS_WLS` | （空） | Mathematica图件额外依赖 |
| `DEPS_FIGS_PYT` | （空） | Python图件额外依赖 |

### 输出

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `OUTPUT` | `${BUILD_DIR}/${PROJECT}.pdf` | 主文档输出PDF |
| `FIGS_TEX_PDF` | `$(addprefix ${BUILD_DIR}/,$(FIGS_TEX:.tex=.pdf))` | LaTeX图件输出 |
| `FIGS_OCT_PDF` | `$(addprefix ${BUILD_DIR}/,$(FIGS_OCT:.m=.pdf))` | Octave图件输出 |
| `FIGS_WLS_PDF` | `$(addprefix ${BUILD_DIR}/,$(FIGS_WLS:.wls=.pdf))` | Mathematica图件输出 |
| `FIGS_PYT_PDF` | `$(addprefix ${BUILD_DIR}/,$(FIGS_PYT:.py=.pdf))` | Python图件输出 |
| `FIGS_PDF` | `${FIGS_TEX_PDF} ${FIGS_OCT_PDF} ${FIGS_WLS_PDF} ${FIGS_PYT_PDF}` | 全部图件PDF |
| `FIGS_SVG` | `$(FIGS_PDF:.pdf=.svg)` | 全部图件SVG |
| `FIGS_EPS` | `$(FIGS_PDF:.pdf=.eps)` | 全部图件EPS |

## 目标

### 构建目标

| 目标 | 说明 |
|------|------|
| `default` | 编译主文档及全部图件 |
| `run` | 同`default`，编译后打开PDF |
| `clean` | 删除`${BUILD_DIR}`目录 |
| `svg` | 将全部图件PDF转换为SVG |
| `eps` | 将全部图件PDF转换为EPS |
| `figs-tex-pdf` | 仅编译LaTeX图件 |
| `figs-oct-pdf` | 仅编译Octave图件 |
| `figs-wls-pdf` | 仅编译Mathematica图件 |
| `figs-pyt-pdf` | 仅编译Python图件 |
| `figs-pdf` | 编译全部图件 |

### 隐含规则

| 规则 | 说明 |
|------|------|
| `%.fig.pdf` ← `%.fig.tex` | 用`latexmk`编译LaTeX图件 |
| `%.fig.pdf` ← `%.fig.m` | 用`octave-cli`执行Octave图件 |
| `%.fig.pdf` ← `%.fig.wls` | 用`wolframscript`执行Mathematica图件 |
| `%.fig.pdf` ← `%.fig.py` | 用`python`执行Python图件 |
| `%.fig.svg` ← `%.fig.pdf` | 用`inkscape`转换PDF至SVG |
| `%.fig.eps` ← `%.fig.pdf` | 用`inkscape`转换PDF至EPS |
