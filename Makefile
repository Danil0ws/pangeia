# Pangeia - developer tasks. Run `make help` for the list.
.DEFAULT_GOAL := help
SHELL := /usr/bin/env bash

.PHONY: help test lint fmt docs install clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

test: ## Run the test suite
	bash tests/run.sh

lint: ## Check the shell scripts with shellcheck
	shellcheck --version >/dev/null 2>&1 || { echo "shellcheck not installed"; exit 1; }
	find . -name '*.sh' -not -path './site/*' -print0 | xargs -0 shellcheck
	shellcheck bin/pangeia

fmt: ## Format the shell scripts with shfmt
	shfmt -w -i 4 -ci .

docs: ## Build the documentation site
	mkdocs build

install: ## Install Pangeia on this machine
	./install.sh

clean: ## Remove build output
	rm -rf site dist
