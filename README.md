# MakefileLaTeX

MakefileLaTeX提供了一个适用于LaTeX项目的构建系统，以Git子模块方式引入，基于`latexmk`，支持多种图片生成链（LaTeX/Octave/Mathematica/Python/Inkscape）。

## 文件组成

| 文件 | 说明 |
|------|------|
| `latex-std-dependence.mk` | 标准依赖变量，声明所有Class和Package的子模块文件路径 |
| `makefile-latex.mk` | 主构建文件，定义变量、目标和编译规则 |

## 引入方式

在项目根目录的`Makefile`中：

```makefile
PROJECT:=MyProject

include makefile-latex/latex-std-dependence.mk
DEPS_MAIN_TEX:=${STYS_MINIMUS} ${CLSS_NOTEBOOK_NEON}

include makefile-latex/makefile-latex.mk
```

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
| `LATEX_MAIN_FLAGS` | `{上两项组合} -synctex=1 ...` | 主文档编译参数 |
| `LATEX_FIGS_FLAGS` | `{上两项组合} -synctex=1 ...` | 图件编译参数 |
| `OCTAVE` | `octave-cli` | Octave解释器 |
| `WOLFRAM` | `wolframscript` | Mathematica解释器 |
| `PYTHON` | `python` | Python解释器 |
| `INKSCAPE` | `inkscape` | Inkscape矢量转换器 |

### 源文件

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `TEXS` | `*.tex`（排除`*.fig.tex`） | 全部LaTeX源文件 |
| `MAIN_TEX` | `${PROJECT}.tex` | 主LaTeX文件 |
| `FIGS_TEX` | `*.fig.tex` | LaTeX图件源文件 |
| `FIGS_OCT` | `*.fig.m` | Octave图件源文件 |
| `FIGS_WLS` | `*.fig.wls` | Mathematica图件源文件 |
| `FIGS_PYT` | `*.fig.py` | Python图件源文件 |

### 依赖

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `DEPS_MAIN_TEX` | 空 | 主文档额外依赖，如`${STYS_MINIMUS}` |
| `DEPS_FIGS_TEX` | 空 | LaTeX图件额外依赖 |
| `DEPS_FIGS_OCT` | 空 | Octave图件额外依赖 |
| `DEPS_FIGS_WLS` | 空 | Mathematica图件额外依赖 |
| `DEPS_FIGS_PYT` | 空 | Python图件额外依赖 |

### 输出

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `OUTPUT` | `${BUILD_DIR}/${PROJECT}.pdf` | 主文档输出PDF |
| `FIGS_TEX_PDF` | `${BUILD_DIR}/*.fig.pdf` | LaTeX图件输出 |
| `FIGS_OCT_PDF` | `${BUILD_DIR}/*.fig.pdf` | Octave图件输出 |
| `FIGS_WLS_PDF` | `${BUILD_DIR}/*.fig.pdf` | Mathematica图件输出 |
| `FIGS_PYT_PDF` | `${BUILD_DIR}/*.fig.pdf` | Python图件输出 |
| `FIGS_PDF` | 以上合并 | 全部图件PDF |
| `FIGS_SVG` | 对应`.svg` | 全部图件SVG |
| `FIGS_EPS` | 对应`.eps` | 全部图件EPS |

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

## 文件关系

`latex-std-dependence.mk`将被项目顶层的`Makefile`首先`include`，然后指定`DEPS_*`变量，再`include makefile-latex.mk`。

`latex-std-dependence.mk`提供了Minimus、NotebookNeon、ArticleArgon、BeamerBismuth、StandaloneSilicon、IEEETran、SI200MiniReview、PyJool这些子模块的文件路径变量，命名统一为`STYS_`（宏包）、`CLSS_`（文档类）、`PYTS_`（Python包）前缀。
