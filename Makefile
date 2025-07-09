SOURCE_FILE_NAME = redis.md
BOOK_FILE_NAME = redis

DOCKER_IMAGE = pandoc-xelatex-new-fonts
PDF_TEMPLATE = /data/common/pdf-template-ua.tex

PDF_BUILDER = docker run --rm -v "$$(pwd)":/data $(DOCKER_IMAGE) pandoc
PDF_BUILDER_FLAGS = \
	--pdf-engine=xelatex \
	--template $(PDF_TEMPLATE) \
	--listings

.PHONY: build-image ua-pdf

ua-pdf:
	$(PDF_BUILDER) $(PDF_BUILDER_FLAGS) /data/ua/$(SOURCE_FILE_NAME) -o /data/ua/$(BOOK_FILE_NAME).pdf

build-image:
	docker build -t pandoc-xelatex-new-fonts -f Dockerfile . --load 