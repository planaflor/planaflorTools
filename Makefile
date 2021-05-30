.DEFAULT_GOAL := help

R := Rscript --no-init-file -e

PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)

.PHONY: help tests clean

all: install tests check clean ## run install_deps, build, install, tests, check, and clean

document: ## refresh function documentation
	$(R) "devtools::document()"

build: document ## build package
	$(R) "devtools::build(vignettes = FALSE)"

check: ## check package
	$(R) "Sys.setenv('_R_CHECK_SYSTEM_CLOCK_' = 0); devtools::check(document = FALSE, build_args = c('--no-build-vignettes'))"

styler: ## styler package
	$(R) "styler::style_dir('R')"

tests: ## run test
	$(R) "devtools::test()"

build_site: ## build pkgdown site
	$(R) "pkgdown::build_site()"

install_deps: ## install dependencies
	$(R) 'if (!requireNamespace("remotes")) install.packages("remotes")' \
	-e 'if (!requireNamespace("dotenv")) install.packages("dotenv")' \
	-e 'if (file.exists(".env")) dotenv::load_dot_env()' \
	-e 'remotes::install_deps(dependencies = TRUE, upgrade = "never")'

install_remote: ## install package from remote version
	$(R) 'if (!requireNamespace("remotes")) install.packages("remotes")' \
	-e 'remotes::install_github("planaflor/planaflorTools")'

install: install_deps build ## install package
	cd ..; \
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

quick_install: build ## quick install (document, build, install) tar package version (used in development)
	cd ..; \
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

clean: ## clean *.tar.gz *.Rcheck
	cd ..; \
	$(RM) -rv $(PKGNAME)_$(PKGVERS).tar.gz $(PKGNAME).Rcheck

README.md: README.Rmd ## render README
	$(R) "rmarkdown::render('$<')"

render: ## force render README
	$(R) "rmarkdown::render('README.Rmd')"

eg:     ## run examples
	$(R) "devtools::run_examples(run_dontrun = TRUE)"

help:         ## show this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
