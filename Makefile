MAIN := Thesis

# Same TeX Live image the GitHub Actions workflow uses, so a local build that
# succeeds will succeed in CI. Runs as the calling user so output files are not
# owned by root; HOME is redirected because /root is not writable then.
DOCKER_IMAGE := texlive/texlive:latest
DOCKER_RUN := docker run --rm -u "$$(id -u):$$(id -g)" -e HOME=/tmp \
	-v "$$(pwd)":/thesis -w /thesis $(DOCKER_IMAGE)

LATEXMK_ARGS := -pdf -file-line-error -interaction=nonstopmode

.PHONY: thesis propositions chapter portfolio all docker docker-propositions \
	docker-chapter docker-portfolio docker-lint shell clean distclean

## --- Native build (needs a full local TeX Live with latexmk + biber) --------

thesis:
	latexmk $(LATEXMK_ARGS) $(MAIN).tex

propositions:
	latexmk $(LATEXMK_ARGS) Propositions/Propositions.tex

# Build one chapter on its own, e.g.
#   make chapter CHAPTER=Chapters/Backmatter/Portfolio/Portfolio.tex
# Chapter files have no \documentclass, so build-chapter.sh wraps them in a
# generated root document that reuses the preamble of Thesis.tex.
chapter:
	./build-chapter.sh $(CHAPTER)

portfolio:
	./build-chapter.sh Chapters/Backmatter/Portfolio/Portfolio.tex

all: thesis propositions

## --- Docker build (no local TeX Live needed) -------------------------------

docker:
	$(DOCKER_RUN) latexmk $(LATEXMK_ARGS) $(MAIN).tex

docker-propositions:
	$(DOCKER_RUN) latexmk $(LATEXMK_ARGS) Propositions/Propositions.tex

# make docker-chapter CHAPTER=Chapters/Backmatter/Portfolio/Portfolio.tex
docker-chapter:
	$(DOCKER_RUN) ./build-chapter.sh $(CHAPTER)

docker-portfolio:
	$(DOCKER_RUN) ./build-chapter.sh Chapters/Backmatter/Portfolio/Portfolio.tex

docker-lint:
	$(DOCKER_RUN) chktex -q -l .chktexrc -v1 -I1 -H1 $(MAIN).tex

# Interactive shell in the TeX Live container, for debugging
shell:
	docker run --rm -it -u "$$(id -u):$$(id -g)" -e HOME=/tmp \
		-v "$$(pwd)":/thesis -w /thesis $(DOCKER_IMAGE) bash

## --- Housekeeping ----------------------------------------------------------

clean:
	@rm -rf *.acr *.alg *.glg *.gls *.out *.synctex *.toc *.acn *.aux *.bbl *.bcf *.blg *.dvi *.fdb_latexmk *.fls *.flg *.flo *.glo *.ist *.log *.run.xml *.synctex.gz
	@rm -f temp_manuscript.*
	@rm -rf Propositions/*.aux Propositions/*.bcf Propositions/*.blg Propositions/*.bbl \
		Propositions/*.fls Propositions/*.fdb_latexmk Propositions/*.log Propositions/*.run.xml

# Also remove the generated PDFs
distclean: clean
	@rm -f $(MAIN).pdf Propositions.pdf
