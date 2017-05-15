.PHONY: default
ifdef version
default: .check-env libmozjs-$(version)
else
default:
	$(error version is undefined)
endif


.PHONY: install
ifdef version
install: .check-env install-$(version)
else
install:
	$(error version is undefined)
endif


firefox-%.source.tar.xz:
	wget "https://archive.mozilla.org/pub/firefox/releases/$(patsubst firefox-%.source.tar.xz,%,$@)/source/$@" -O "$@" || rm "$@"


firefox-%: firefox-%.source.tar.xz
	tar xvJf $<


firefox-%/js/src/Makefile: firefox-%
	cd $</js/src/ && ./configure --enable-optimize


.PHONY: libmozjs-%
libmozjs-%: firefox-% firefox-%/js/src/Makefile
	cd $</js/src/ && $(MAKE) && $(MAKE) install prefix=$(realpath .)


.PHONY: install-%
install-%: firefox-% libmozjs-%
	cd $</js/src/ && $(MAKE) install


.PHONY: .check-env
.check-env:
ifndef version
	$(error version is undefined)
endif
