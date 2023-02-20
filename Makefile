#!make
SHELL=/bin/bash
.ONESHELL:

KUBERNETES_RELEASE_VERSION := $(shell grep 'kubernetes_release_version:' version.yaml | awk '{print $$2}')
SUSE_BCI_BASE_VERSION := $(shell grep 'suse_bci_base_version:' version.yaml | awk '{print $$2}')
DIGI_LAB_IO_K8S_CLI_VERSION := $(shell grep 'digi_lab_io_k8s_cli_version:' version.yaml | awk '{print $$2}')
KREW_VERSION := $(shell grep 'krew_version:' version.yaml | awk '{print $$2}')
ARCH := $(shell grep 'arch:' version.yaml | awk '{print $$2}')

IMAGE_TAG_LATEST=ghcr.io/digi-lab-io/digi-lab-io-k8s-cli-tools:latest
IMAGE_TAG_SEMVER=ghcr.io/digi-lab-io/digi-lab-io-k8s-cli-tools:$(KUBERNETES_RELEASE_VERSION)-$(DIGI_LAB_IO_K8S_CLI_VERSION)

CCMD = $(shell command -v nerdctl 2> /dev/null)

ifeq (,$(findstring nerdctl,$(CCMD)))
	CCMD = $(shell command -v docker 2> /dev/null)
endif

build:
	@${CCMD} build --no-cache \
		--build-arg kubernetes_release_version=$(KUBERNETES_RELEASE_VERSION) \
		--build-arg suse_bci_base_version=$(SUSE_BCI_BASE_VERSION) \
		--build-arg krew_version=$(KREW_VERSION) \
		--build-arg arch=$(ARCH) \
		-t $(IMAGE_TAG_SEMVER) .

push:
	@${CCMD} tag ${IMAGE_TAG_SEMVER} ${IMAGE_TAG_LATEST}
	@${CCMD} push ${IMAGE_TAG_SEMVER}
	@echo "Pushed ${IMAGE_TAG_SEMVER}"
	@${CCMD} push ${IMAGE_TAG_LATEST}
	@echo "Pushed ${IMAGE_TAG_LATEST}"

bump-patch:
	@echo "Bumping patch version from $(DIGI_LAB_IO_K8S_CLI_VERSION) to $$(echo $(DIGI_LAB_IO_K8S_CLI_VERSION) | awk -F. '{$$NF=$$NF+1;} 1' OFS=.)"
	@sed -i "" "s/digi_lab_io_k8s_cli_version: $(DIGI_LAB_IO_K8S_CLI_VERSION)/digi_lab_io_k8s_cli_version: $$(echo $(DIGI_LAB_IO_K8S_CLI_VERSION) | awk -F. '{$$NF=$$NF+1;} 1' OFS=.)/g" version.yaml

bump-minor:
	@echo "Bumping minor version from $(DIGI_LAB_IO_K8S_CLI_VERSION) to $$(echo $(DIGI_LAB_IO_K8S_CLI_VERSION) | awk -F. '{$$NF=$$NF+1;} 1' OFS=.)"
	@sed -i "" "s/digi_lab_io_k8s_cli_version: $(DIGI_LAB_IO_K8S_CLI_VERSION)/digi_lab_io_k8s_cli_version: $$(echo $(DIGI_LAB_IO_K8S_CLI_VERSION) | awk -F. '{$$NF=$$NF+1;} 1' OFS=.)/g" version.yaml

bump-major:
	@echo "Bumping major version from $(DIGI_LAB_IO_K8S_CLI_VERSION) to $$(echo $(DIGI_LAB_IO_K8S_CLI_VERSION) | awk -F. '{$$1=$$1+1; $$2=0; $$3=0;} 1' OFS=.)"
	@sed -i "" "s/digi_lab_io_k8s_cli_version: $(DIGI_LAB_IO_K8S_CLI_VERSION)/digi_lab_io_k8s_cli_version: $$(echo $(DIGI_LAB_IO_K8S_CLI_VERSION) | awk -F. '{$$1=$$1+1; $$2=0; $$3=0;} 1' OFS=.)/g" version.yaml
