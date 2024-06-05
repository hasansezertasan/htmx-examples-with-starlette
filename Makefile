# Makefile for project management
.DEFAULT_GOAL:=all
SOURCE_BASE_PATH = node_modules
TARGET_BASE_PATH = app/static/vendor

.PHONY: help
help:
	@echo "Usage: make [command]"
	@echo ""
	@echo "Commands:"
	@echo "  help                Show this help message"
	@echo "  install             Install dependencies"
	@echo "  copy-vendor         Copy vendor files"
	@echo "  delete-vendor       Delete vendor files"
	@echo "  delete-node-modules Delete Node Modules"
	@echo "  lint                Lint the code"
	@echo "  format              Format the code"
	@echo "  test                Run tests"
	@echo "  line-count          Count lines of code"
	@echo "  clean-cache-files   Clean cache files"
	@echo "  run                 Run the application"


.PHONY: install
install:
	@echo "Installing Python dependencies..."
	poetry shell
	poetry lock
	poetry install
	@echo "Installing Node dependencies..."
	npm install

.PHONY: copy-vendor
copy-vendor:
	@echo "Copying HTMX..."
	mkdir -p $(TARGET_BASE_PATH)/htmx
	cp -a $(SOURCE_BASE_PATH)/htmx.org/dist/. $(TARGET_BASE_PATH)/htmx

.PHONY: delete-vendor
delete-vendor:
	rm -rf starlette_admin/statics/vendor

.PHONY: delete-node-modules
delete-node-modules:
	rm -rf node_modules

.PHONY: lint
lint:
	ruff check .
	djlint --lint .
	codespell .

.PHONY: format
format:
	ruff format .
	djlint --reformat .

.PHONY: test
test:
	pytest -v -s tests

.PHONY: line-count
line-count:
	pygount --format=summary --folders-to-skip=vendor,node_modules .

.PHONY: clean-cache-files
clean-cache-files:
	frenchmaid clean

.PHONY: run
run:
	uvicorn main:app --port 8000 --reload
