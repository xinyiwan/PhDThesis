MAIN := Thesis

# Same TeX Live image the GitHub Actions workflow uses, so a local build that
# succeeds will succeed in CI. Runs as the calling user so output files are not
# owned by root; HOME is redirected because /root is not writable then.
DOCKER_IMAGE := texlive/texlive:latest
DOCKER_RUN := docker run --rm -u "$$(id -u):$$(id -g)" -e HOME=/tmp \
	-v "$$(pwd)":/thesis -w /thesis $(DOCKER_IMAGE)

LATEXMK_ARGS := -pdf -file-line-error -interaction=nonstopmode

# Every chapter file is auto-discovered and gets two targets named after its
# lowercased file name: `make introduction` and `make docker-introduction`
# (likewise discussion, chapter01, chapter02, portfolio, summary, cv, ...).
CHAPTER_FILES := $(wildcard Chapters/*/*/*.tex Chapters/*/*/*/*.tex)
chapter_name = $(shell basename $(1) .tex | tr '[:upper:]' '[:lower:]')
CHAPTER_NAMES := $(foreach f,$(CHAPTER_FILES),$(call chapter_name,$(f)))

.PHONY: thesis propositions chapter all docker docker-propositions \
	docker-chapter docker-lint shell clean distclean list-chapters \
	$(CHAPTER_NAMES) $(addprefix docker-,$(CHAPTER_NAMES))

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

all: thesis propositions

## --- Docker build (no local TeX Live needed) -------------------------------

docker:
	$(DOCKER_RUN) latexmk $(LATEXMK_ARGS) $(MAIN).tex

docker-propositions:
	$(DOCKER_RUN) latexmk $(LATEXMK_ARGS) Propositions/Propositions.tex

# make docker-chapter CHAPTER=Chapters/Backmatter/Portfolio/Portfolio.tex
docker-chapter:
	$(DOCKER_RUN) ./build-chapter.sh $(CHAPTER)

docker-lint:
	$(DOCKER_RUN) chktex -q -l .chktexrc -v1 -I1 -H1 $(MAIN).tex

# Interactive shell in the TeX Live container, for debugging
shell:
	docker run --rm -it -u "$$(id -u):$$(id -g)" -e HOME=/tmp \
		-v "$$(pwd)":/thesis -w /thesis $(DOCKER_IMAGE) bash

## --- Per-chapter shortcuts (generated) -------------------------------------

define CHAPTER_RULES
$(call chapter_name,$(1)):
	./build-chapter.sh $(1)
docker-$(call chapter_name,$(1)):
	$$(DOCKER_RUN) ./build-chapter.sh $(1)
endef
$(foreach f,$(CHAPTER_FILES),$(eval $(call CHAPTER_RULES,$(f))))

list-chapters:
	@printf '%s\n' $(CHAPTER_NAMES)

## --- Housekeeping ----------------------------------------------------------

clean:
	@rm -rf *.acr *.alg *.glg *.gls *.out *.synctex *.toc *.acn *.aux *.bbl *.bcf *.blg *.dvi *.fdb_latexmk *.fls *.flg *.flo *.glo *.ist *.log *.run.xml *.synctex.gz
	@rm -f temp_manuscript.*
	@rm -rf Propositions/*.aux Propositions/*.bcf Propositions/*.blg Propositions/*.bbl \
		Propositions/*.fls Propositions/*.fdb_latexmk Propositions/*.log Propositions/*.run.xml

# Also remove the generated PDFs
distclean: clean
	@rm -f $(MAIN).pdf Propositions.pdf \
		$(foreach f,$(CHAPTER_FILES),$(notdir $(basename $(f))).pdf)
