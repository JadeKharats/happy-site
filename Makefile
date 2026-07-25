# Happy — tutorial site
#
# The site is a thin shell: prose is vendored from each app repo at build time.
# `make serve` for local writing, `make build` for the production output.

.PHONY: help vendor serve build clean doctor

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

vendor: ## Fetch tutorials from the app repos into content/tutorials/
	@bash scripts/vendor.sh

serve: vendor ## Vendor, then run the dev server with live reload
	@hwaro serve

build: vendor ## Vendor, then build the production site into public/
	@hwaro build --minify

doctor: ## Diagnose config, templates, and structure
	@hwaro doctor

clean: ## Remove build output and vendored content
	@rm -rf public content/tutorials templates/partials/tutorial-nav.html
	@echo "clean: removed public/, content/tutorials/, generated nav partial"
