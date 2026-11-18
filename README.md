# PhD Thesis

LaTeX source of my PhD thesis.

The template is derived from the thesis of [Martijn P. A. Starmans](https://github.com/MStarmans91/PhDThesis),
which in turn is based on the thesis of [Sebastian R. van der Voort](https://github.com/Svdvoort/PhDThesis).
All personal content has been removed; the LaTeX machinery is kept.

The latest compiled PDF is always available under
[the 'releases' tab](../../releases) (see the 'assets' of a release).

## Layout

| Path | Purpose |
| --- | --- |
| `Thesis.tex` | Main document: sets bleed/cover flags and imports every chapter |
| `Settings/title_page.tex` | **Your name, title, committee, defense date, ISBN** |
| `Settings/` | Layout, colours, commands, tables, TikZ setup, acronyms/glossary |
| `thesis.sty` | Package loading and global formatting |
| `ErasmusTitlePage.sty` | Official Erasmus MC title, copyright and committee pages |
| `Chapters/Mainmatter/` | Introduction, publication chapters, general discussion |
| `Chapters/Backmatter/` | Summary, samenvatting, acknowledgements, CV, publications, portfolio |
| `Bibliographies/references.bib` | Main bibliography |
| `Bibliographies/self.bib` | Your own publications (`\publishedas`, list of publications) |
| `Propositions/` | Standalone propositions ("stellingen") document |
| `Cover/` | Cover artwork PDFs (see `Cover/README.md`) |
| `Packages/` | Logos and images used by the title pages |

## Getting started

1. Fill in `Settings/title_page.tex` (name, title, committee, defense date, ISBN).
2. Update the funding statement, colophon and copyright exceptions in the
   `\makecopyrightpage` command in `ErasmusTitlePage.sty`.
3. Replace the `TODO` stubs in `Chapters/`, and add/remove `\subimport` lines and
   `\part{...}` titles in `Thesis.tex` to match your chapters.
4. Put your references in `Bibliographies/`.
5. Update the copyright holder in `LICENSE` and the acronyms in
   `Settings/glossary_items.tex`.

### Adding a chapter

Create `Chapters/Mainmatter/Publications/MyChapter/MyChapter.tex`, copy the
structure of `Chapter01.tex`, and add to `Thesis.tex`:

```latex
\subimport{Chapters/Mainmatter/Publications/MyChapter/}{MyChapter.tex}
\clearemptydoublepageeven
```

Chapters may open with a designed divider page: drop
`MyChapterTitlePage.pdf` (digital) and `MyChapterTitlePageBleed.pdf` (print,
3 mm bleed) next to the `.tex` file and uncomment the `\includepdf` block.

### Conventions for publication chapters

Follow these when turning a published paper into a chapter (see
`Chapters/Mainmatter/Publications/Chapter02/Chapter02.tex` for a worked
example). The published PDF is the source of truth; Word files are only a
convenience for copying text.

**Files**

- Chapter text: `ChapterXX/ChapterXX.tex`; figures extracted from the PDF
  (`pdfimages -all paper.pdf out`) go in `ChapterXX/Figures/`, named
  `Figure1_short_name.jpg`, `FigureS1_short_name.jpg`, ...
- Reference-list entries go in `Bibliographies/references.bib`, one key per
  paper (`firstauthorYEAR`, e.g. `zhang2021`; add a suffix if ambiguous). DOIs
  can be recovered from the link annotations of the published PDF. Cite with
  `\autocite{a,b}`.
- The chapter's own paper goes in `Bibliographies/self.bib`.

**Abstract**

- Use `\begin{ChapterAbstract}...\end{ChapterAbstract}`. It always starts on
  its own page (after the chapter title page) and renders as a centred bold
  "Abstract" title with italic, justified text.
- For structured abstracts write four paragraphs, each starting with a bold
  label: `\textbf{Background:}`, `\textbf{Methods:}`, `\textbf{Findings:}`,
  `\textbf{Interpretation:}`. (Use `\textbf{}`, not `\bf{}` — `\bf` fails the
  `nag` check.) All paragraphs are indented identically so the labels line up.
- Publication info is printed automatically at the bottom of the abstract page
  (rule + "Published as: ..."), not on a separate page. Set it *before* the
  abstract with `\publishedas{key}`. For shared first authors use
  `\publishedasco{key}` and put a `\textsuperscript{*}` after those family
  names in `self.bib` (this also prints "* Contributed equally"). All authors
  are listed because the entry carries `options = {maxnames=99,maxbibnames=99}`;
  copy that for new entries.

**Citations**

- Numeric style with ranges compressed (`numeric-comp` in `thesis.sty`):
  `[5–7, 11–18]`, `[24, 30–34]`; two consecutive numbers stay `[20, 21]`.
  Never type ranges by hand; just cite every key.

**Bibliography format**

- IEEE style (`style=ieee` in `thesis.sty`). Reference entries with up to 6
  authors list everyone; with more than 6 the first six are listed followed by
  "et al." (`maxbibnames=6,minbibnames=6`). The IEEE guide itself prints only
  the first author + "et al." for more than six; set `minbibnames=1` to follow
  that instead.
- The "Published as" line on the abstract page lists all authors (per-entry
  `options = {maxnames=99,maxbibnames=99}` in `self.bib`).
- The bibliography has its own title page; the references start on the next
  page (`bibintoc` heading in `Settings/command.tex`).

**Tables**

- Caption above the table, full text width, normal font size with a bold
  "Table X.Y:" label (set in `Settings/layout.tex`).
- Use `booktabs` (`\toprule`, `\midrule`, `\bottomrule`), bold header cells and
  `\textit{}` sub-headers spanning the row (`\multicolumn{5}{@{}l}{...}`).
- Put footnotes/abbreviations under the table in a
  `\parbox{\textwidth}{\footnotesize ...}`.
- For long text in a column use the `L{width}` column type from
  `Settings/table.tex` (left-aligned, no justification gaps). Use
  `\footnotesize` for wide numeric tables and check there are no `Overfull`
  warnings.
- Very large tables (e.g. the 564-feature overview) go in a `sidewaystable`
  (landscape page) with `\scriptsize`, one `p`-column per group and the items
  separated by `\newline`; keep the full caption. Put a `\clearpage` before the
  following subsection so floats cannot end up after the wrong heading.
- Label tables `tab:chN_name` and figures `fig:chN_name`; refer with
  `\autoref{}`.

**Supplementary material**

- Put it in the last section of the chapter, always starting on a new page
  (`\clearpage` before `\section{Supplementary Material}`).
- A tall figure can be rotated 90 degrees counterclockwise (figure left,
  caption right) with `\rotatebox{90}{\begin{minipage}{0.95\textheight}...`;
  typeset its caption by hand (see Figure S2 in `Chapter02.tex`).
- Tables/figures are numbered with the chapter; keep the original number in
  the caption, e.g. `(Table S1)`, and refer to them with `\autoref{}`.

**Checks before committing**

- `make docker-chapterNN` compiles with no `!` errors, no `??` in the PDF and
  no new `Overfull` warnings. Chapter numbers in a single-chapter build start
  at 1; run `make docker` for the real numbering.

## Building locally

### With Docker (recommended, no TeX install needed)

Uses `texlive/texlive:latest` — the same image as the CI workflow, so a local
build that succeeds will also succeed on GitHub.

```sh
make docker                # build Thesis.pdf
make docker-propositions   # build Propositions.pdf
make docker-lint           # run chktex
make shell                 # interactive shell in the container, for debugging
```

Check the PDF before every push:

```sh
make docker && open Thesis.pdf
```

### Building a single chapter

Chapter `.tex` files are fragments — they start at `\chapter` and have no
`\documentclass`, so `latexmk` cannot compile them directly. `build-chapter.sh`
generates a throwaway root document (`temp_manuscript.tex`, gitignored) that
reuses the whole preamble of `Thesis.tex` and imports just that one chapter.
This is what the `% !TEX root = ../../../temp_manuscript.tex` comment at the top
of each chapter refers to.

```sh
make docker-introduction   # -> Introduction.pdf
make docker-portfolio      # -> Portfolio.pdf
make list-chapters         # show all available chapter names
make docker-chapter CHAPTER=Chapters/Mainmatter/Publications/Chapter01/Chapter01.tex
```

The PDF is written to the repository root and is gitignored. Native equivalents
are `make introduction`, `make portfolio`, ... and `make chapter CHAPTER=...`.
Every file under `Chapters/` automatically gets a `make <name>` and
`make docker-<name>` target, where `<name>` is the lowercased file name
(`introduction`, `discussion`, `chapter01`, `chapter02`, `summary`, `cv`, ...).

Cross-references to other chapters will show as `??` in a single-chapter build,
since the other chapters are not part of the generated document. Always check
the full `make docker` before pushing.

The underlying command, if you prefer to run it by hand:

```sh
docker run --rm -u "$(id -u):$(id -g)" -e HOME=/tmp \
  -v "$PWD":/thesis -w /thesis texlive/texlive:latest \
  latexmk -pdf -file-line-error -interaction=nonstopmode Thesis.tex
```

`-u` keeps the generated files owned by you instead of `root`; `-e HOME=/tmp`
is then needed because `/root` is no longer writable and `latexmk` wants a
writable `$HOME`.

### With a native TeX Live

Requires a **full** TeX Live (memoir, biblatex + biber, glossaries, pgfplots,
nag) and `latexmk` — BasicTeX/MacTeX-small is not enough. The glossary rules
live in `.latexmkrc`.

```sh
make thesis
make propositions
./bibtest.sh                                 # validate the .bib files with biber
chktex -l .chktexrc -v1 -I1 -H1 Thesis.tex   # lint
```

### Housekeeping

```sh
make clean       # remove auxiliary files
make distclean   # also remove the generated PDFs
```

Print vs digital output is controlled at the top of `Thesis.tex`:

- `\def\setbleed{}` — no 3 mm bleed (digital). Non-empty for printing.
- `\def\setcover{}` — no cover. Non-empty to include `Cover/Voorkant.pdf` and
  `Cover/Achterkant.pdf`.

## Continuous integration

[`.github/workflows/main.yml`](.github/workflows/main.yml) compiles the thesis
and the propositions on every push and pull request, and uploads the PDFs plus
the build logs as artifacts.

- push to `main` → dated **pre-release** with both PDFs attached
- push a `v*` tag (e.g. `git tag v1.0 && git push origin v1.0`) → full release

`chktex` runs as a separate, non-blocking lint job.

## License

The LaTeX code is licensed under an MIT License (see `LICENSE`).

This excludes chapters that have been published elsewhere: their copyright has
been transferred to the publisher and they carry their own license. List those
per chapter on the copyright page in `ErasmusTitlePage.sty`.
