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

## Building locally

Requires a full TeX Live (memoir, biblatex + biber, glossaries, pgfplots) and
`latexmk`. The glossary rules live in `.latexmkrc`.

```sh
latexmk -pdf Thesis.tex          # thesis
latexmk -pdf Propositions/Propositions.tex
make clean                       # remove auxiliary files
./bibtest.sh                     # validate the .bib files with biber
chktex -l .chktexrc -v1 -I1 -H1 Thesis.tex   # lint
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
