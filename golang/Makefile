LOCAL_DIRECTORY := ${HOME}/.local
GO_INSTALL_DIRECTORY := $(LOCAL_DIRECTORY)/go
GO_VERSION ?= 1.23.2

GO := $(GO_INSTALL_DIRECTORY)/bin/go

UNAME_S := $(shell uname -s | tr '[:upper:]' '[:lower:]')
UNAME_M := $(shell uname -m)
ifeq ($(UNAME_M),aarch64)
ARCH := arm64
else
ARCH := $(UNAME_M)
endif

.PHONY: setup
setup: setup/go

$(GO_INSTALL_DIRECTORY):
	mkdir -p $(LOCAL_DIRECTORY); \
	rm -rf $(GO_INSTALL_DIRECTORY); \
	curl -L "https://go.dev/dl/go${GO_VERSION}.$(UNAME_S)-$(ARCH).tar.gz" | tar -C $(LOCAL_DIRECTORY) -xz; \
	$(MAKE) version/go
.PHONY: setup/go
setup/go: $(GO_INSTALL_DIRECTORY)
.PHONY: uninstall/go
uninstall/go:
	rm -rf $(GO_INSTALL_DIRECTORY)

.PHONY: version
version: version/go
.PHONY: version/go
version/go:
	$(GO) version

