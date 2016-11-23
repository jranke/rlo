PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
TGZ     := $(PKGNAME)_$(PKGVERS).tar.gz

# Specify the directory holding R binaries. To use an alternate R build (say a
# pre-prelease version) use `make RBIN=/path/to/other/R/` or `export RBIN=...`
# If no alternate bin folder is specified, the default is to use the folder
# containing the first instance of R on the PATH.
RBIN ?= $(shell dirname "`which R`")
#

.PHONY: help

pkgfiles = \
	   DESCRIPTION \
	   inst/py/connect.py \
	   NAMESPACE \
	   R/*

all: check clean

$(TGZ): roxygen $(pkgfiles)
	"$(RBIN)/R" CMD build .

roxygen: 
	"$(RBIN)/Rscript" -e 'library(roxygen2); roxygenize(".")'
                
build: $(TGZ)

install: build
	"$(RBIN)/R" CMD INSTALL $(TGZ)

check: build
	"$(RBIN)/R" CMD check --no-tests --no-build-vignettes $(TGZ)

clean: 
	$(RM) -r $(PKGNAME).Rcheck/

pd:
	"$(RBIN)/Rscript" -e "pkgdown::build_site()"
	git add -A
	git commit -m 'Static documentation rebuilt by pkgdown::build_site()' -e
