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
- 项目的主`Makefile`直接引用`makefile-latex.mk`，复用大部分编译逻辑，仅做简单配置。
- 扁平化设计，所有`.tex`文件都位于项目根目录，不设`src`目录。
- 编译输出统一写入`build`目录，避免污染项目结构。
- 文档可以用`\input`拆分为若干`.tex`，主文件`MyProject`需要写入`PROJECT`变量。
- 插图可以联合编译，后缀必须是`.fig.tex`、`.fig.m`、`.fig.wls`、`.fig.py`，对应TikZ、Octave、Mathematica、Python。
- 插图应在`build`目录生成一个同名的`.fig.pdf`（一个脚本对应一张图），否则会破坏编译链。

```
MyProject
|- build/
    |- MyProject.pdf
    |- FigTikz.fig.pdf
    |- FigOctave.fig.pdf
    |- FigMathematica.fig.pdf
    |- FigPython.fig.pdf
|- makefile-latex/
    |- makefile-latex.mk
    |- latex-std-depence.mk
|- Makefile
|- MyProject.tex
|- Chapter01.tex
|- Chapter02.tex
|- FigTikz.fig.tex
|- FigOctave.fig.m
|- FigMathematica.fig.wls
|- FigPython.fig.py
```

在项目根目录的主`Makefile`中

```makefile
PROJECT:=MyProject

include makefile-latex/makefile-latex.mk
```

在`makefile-latex.mk`中，变量都是通过`?=`定义的，因此可以在`Makefile`中引用该文件前抢先定义以覆盖默认值，实现配置。

编译文档及其插图

```bash
make -j
```

清理文档输出目录

```bash
make clean
```

将所有`.fig.pdf`转换为SVG格式

```bash
make svg
```

将所有`.fig.pdf`转换为EPS格式

```bash
make eps
```

所有的变量理论上都是可配置的，但是有一些组合特别实用，罗列如下。

特别注意，所有`Makefile`中对`makefile-latex.mk`的变量的默认值覆写都必须出现在它被引用前。

### 编译器修改

默认的编译器是`xelatex`，若需要为`.tex`和`.fig.tex`设置不同的编译器（例如IEEETran必须用`pdflatex`）

```makefile
LATEX_MAIN_COMPILER:=-pdf
LATEX_FIGS_COMPILER:=-xelatex
```

该变量最终将作为`latexmk`的参数，使用`-xelatex`代表`xelatex`，使用`-pdf`编译器代表`pdflatex`编译器。

### 依赖项修改

默认文档和图片的PDF仅会依赖`.tex`和`.fig.tex`，但可以额外添加一些依赖，当文档使用了某些自定义的`.cls`和`.sty`。

`latex-std-dependence.mk`包含了Lumos LaTeX计划定义的Package和Class的依赖路径，例如

```makefile
include makefile-latex/latex-std-dependence.mk

DEPS_MAIN_TEX:=${STYS_MINIMUS} ${CLSS_NOTEBOOK_NEON}
DEPS_FIGS_TEX:=${STYS_MINIMUS} ${CLSS_STANDALONE_SILICON}
```

`latex-std-dependence.mk`中定义了以下变量（相关子模块必须以正确的路径引入）

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

### 警告

**不要试图通过`BUILD_DIR=.`的方式令输出保持在当且目录，否则使用`make clean`将会删除全部源代码！**

## 变量

### 项目配置

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `PROJECT` | `Notebook` | 项目名称 |
| `BUILD_DIR` | `build` | 输出目录 |

### 编译器

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `LATEX` | `latexmk` | LaTeX编译器 |
| `LATEX_MAIN_COMPILER` | `-xelatex` | 文档编译器选项 |
| `LATEX_FIGS_COMPILER` | `-xelatex` | 图片编译器选项 |
| `LATEX_MAIN_FLAGS` | `${LATEX_MAIN_COMPILER} -synctex=1 -interaction=nonstopmode -file-line-error -output-directory=${BUILD_DIR}` | 文档编译参数 |
| `LATEX_FIGS_FLAGS` | `${LATEX_FIGS_COMPILER} -synctex=1 -interaction=nonstopmode -file-line-error -output-directory=${BUILD_DIR}` | 图片编译参数 |
| `OCTAVE` | `octave-cli` | Octave解释器 |
| `OCTAVE_FLAGS` | -- | Octave编译参数 |
| `WOLFRAM` | `wolframscript` | Mathematica解释器 |
| `WOLFRAM_FLAGS` | `-script` | Mathematica编译参数 |
| `PYTHON` | `python` | Python解释器 |
| `PYTHON_FLAGS` | -- | Python编译参数 |
| `INKSCAPE` | `inkscape` | Inkscape矢量转换器 |
| `INKSCAPE_FLAGS` | -- | Inkscape编译参数 |

### 源文件

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `TEXS` | `$(filter-out $(wildcard *.fig.tex),$(wildcard *.tex))` | 文档源文件 |
| `MAIN_TEX` | `${PROJECT}.tex` | 文档主文件 |
| `FIGS_TEX` | `$(wildcard *.fig.tex)` | LaTeX图片源文件 |
| `FIGS_OCT` | `$(wildcard *.fig.m)` | Octave图片源文件 |
| `FIGS_WLS` | `$(wildcard *.fig.wls)` | Mathematica图片源文件 |
| `FIGS_PYT` | `$(wildcard *.fig.py)` | Python图片源文件 |

### 依赖

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `DEPS_MAIN_TEX` | -- | 主文档额外依赖 |
| `DEPS_FIGS_TEX` | -- | LaTeX图片额外依赖 |
| `DEPS_FIGS_OCT` | -- | Octave图片额外依赖 |
| `DEPS_FIGS_WLS` | -- | Mathematica图片额外依赖 |
| `DEPS_FIGS_PYT` | -- | Python图片额外依赖 |

### 输出

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `OUTPUT` | `${BUILD_DIR}/${PROJECT}.pdf` | 主文档输出PDF |
| `FIGS_TEX_PDF` | `$(addprefix ${BUILD_DIR}/,$(FIGS_TEX:.tex=.pdf))` | LaTeX图片输出 |
| `FIGS_OCT_PDF` | `$(addprefix ${BUILD_DIR}/,$(FIGS_OCT:.m=.pdf))` | Octave图片输出 |
| `FIGS_WLS_PDF` | `$(addprefix ${BUILD_DIR}/,$(FIGS_WLS:.wls=.pdf))` | Mathematica图片输出 |
| `FIGS_PYT_PDF` | `$(addprefix ${BUILD_DIR}/,$(FIGS_PYT:.py=.pdf))` | Python图片输出 |
| `FIGS_PDF` | `${FIGS_TEX_PDF} ${FIGS_OCT_PDF} ${FIGS_WLS_PDF} ${FIGS_PYT_PDF}` | 全部图片PDF |
| `FIGS_SVG` | `$(FIGS_PDF:.pdf=.svg)` | 全部图片SVG |
| `FIGS_EPS` | `$(FIGS_PDF:.pdf=.eps)` | 全部图片EPS |

## 目标

### 构建目标

| 目标 | 说明 |
|------|------|
| `default` | 指向`run`，作为`make`的默认行为 |
| `run` | 编译主文档及全部图片 |
| `clean` | 清空输出目录 |
| `svg` | 将全部图片PDF转换为SVG |
| `eps` | 将全部图片PDF转换为EPS |
| `figs-tex-pdf` | 仅编译LaTeX图片 |
| `figs-oct-pdf` | 仅编译Octave图片 |
| `figs-wls-pdf` | 仅编译Mathematica图片 |
| `figs-pyt-pdf` | 仅编译Python图片 |
| `figs-pdf` | 编译全部图片 |
