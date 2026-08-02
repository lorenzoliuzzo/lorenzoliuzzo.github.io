TYPST ?= typst
OUT := ../assets/cv

all: $(OUT)/cv_liuzzo_en.pdf $(OUT)/cv_liuzzo_it.pdf

$(OUT)/cv_liuzzo_%.pdf: cv_%.typ fonts ../assets/images/profile.jpg
	$(TYPST) compile --root .. --font-path fonts $< $@

fonts:
	./fetch-fonts.sh

watch-en: fonts
	$(TYPST) watch --root .. --font-path fonts cv_en.typ $(OUT)/cv_liuzzo_en.pdf

watch-it: fonts
	$(TYPST) watch --root .. --font-path fonts cv_it.typ $(OUT)/cv_liuzzo_it.pdf

clean:
	rm -rf fonts

.PHONY: all watch-en watch-it clean
