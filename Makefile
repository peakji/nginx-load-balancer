NAME := nginx-load-balancer
VERSION := 0.1.0

DOCKER_HUB_OWNER ?= peakji92
DOCKER_HUB_IMAGE := $(DOCKER_HUB_OWNER)/$(NAME):$(VERSION)

GITHUB_PACKAGES_OWNER ?= peakji
GITHUB_PACKAGES_IMAGE := ghcr.io/$(GITHUB_PACKAGES_OWNER)/$(NAME):$(VERSION)

TARGET_CONTAINER_PLATFORMS := linux/386,linux/amd64,linux/arm64

.PHONY: build
build: docker

.PHONY: changelog
changelog:
	@mkdir -p release
	@git log $(shell git describe --tags --abbrev=0 2> /dev/null)..HEAD --pretty='tformat:* [%h] %s' > release/changelog.md
	@cat release/changelog.md

.PHONY: clean
clean:
	@rm -rf release/

.PHONY: docker
docker:
	@docker build --tag $(DOCKER_HUB_IMAGE) .

.PHONY: docker-hub
docker-hub:
	@docker buildx build --push --platform $(TARGET_CONTAINER_PLATFORMS) --tag $(DOCKER_HUB_IMAGE) .

.PHONY: github-packages
github-packages:
	@docker buildx build --push --platform $(TARGET_CONTAINER_PLATFORMS) --tag $(GITHUB_PACKAGES_IMAGE) .

.PHONY: github-release
github-release: changelog
	@gh release create v$(VERSION) -F release/changelog.md -t v$(VERSION)
