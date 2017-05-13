firefox-%.source.tar.xz:
	wget "https://archive.mozilla.org/pub/firefox/releases/$(patsubst firefox-%.source.tar.xz,%,$@)/source/$@" -O "$@" || rm "$@"


firefox-%: firefox-%.source.tar.xz
	tar xvJf $<


firefox-%/js/src/Makefile: firefox-%
	cd $</js/src/ && ./configure --enable-optimize


.PHONY: libmozjs-%
libmozjs-%: firefox-% firefox-%/js/src/Makefile
	cd $</js/src/ && $(MAKE)


.PHONY: install-%
install-%: firefox-% libmozjs-%
	cd $</js/src/ && $(MAKE) install
