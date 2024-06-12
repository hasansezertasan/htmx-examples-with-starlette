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
	@echo "Copying hx-take..."
	mkdir -p $(TARGET_BASE_PATH)/hx-take
	cp -a $(SOURCE_BASE_PATH)/hx-take/dist/. $(TARGET_BASE_PATH)/hx-take
	@echo "Copying hyperscript..."
	mkdir -p $(TARGET_BASE_PATH)/hyperscript
	cp -a $(SOURCE_BASE_PATH)/hyperscript.org/dist/. $(TARGET_BASE_PATH)/hyperscript
	@echo "Copying sortablejs..."
	mkdir -p $(TARGET_BASE_PATH)/sortablejs
	cp -a $(SOURCE_BASE_PATH)/sortablejs/. $(TARGET_BASE_PATH)/sortablejs
	@echo "Copying sweetalert2..."
	mkdir -p $(TARGET_BASE_PATH)/sweetalert2
	cp -a $(SOURCE_BASE_PATH)/sweetalert2/dist/. $(TARGET_BASE_PATH)/sweetalert2
	@echo "Copying uikit..."
	mkdir -p $(TARGET_BASE_PATH)/uikit
	cp -a $(SOURCE_BASE_PATH)/uikit/dist/. $(TARGET_BASE_PATH)/uikit

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
