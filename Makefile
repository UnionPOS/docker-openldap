export DOCKER_ORG ?= unionpos
export DOCKER_IMAGE ?= $(DOCKER_ORG)/openldap
export DOCKER_TAG ?= 1.2.5
export DOCKER_IMAGE_NAME ?= $(DOCKER_IMAGE):$(DOCKER_TAG)
export DOCKER_BUILD_FLAGS =

-include $(shell curl -sSL -o .build-harness "https://raw.githubusercontent.com/unionpos/build-harness/master/templates/Makefile.build-harness"; echo .build-harness)

build: docker/build
.PHONY: build

## update readme documents
docs: readme/deps readme
.PHONY: docs

push:
	$(DOCKER) push $(DOCKER_IMAGE_NAME)
.PHONY: push

run:
	$(DOCKER) container run --rm \
		--publish "389:389" \
		--publish "636:636" \
		--attach STDOUT ${DOCKER_IMAGE_NAME}
.PHONY: run

it:
	$(DOCKER) run -it ${DOCKER_IMAGE_NAME} /bin/bash
.PHONY: it

# test:
# 	env NAME=$(NAME) VERSION=$(VERSION) bats test/test.bats
