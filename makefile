firefox-%.source.tar.xz:
	wget "https://archive.mozilla.org/pub/firefox/releases/$(patsubst firefox-%.source.tar.xz,%,$@)/source/$@" -O "$@" || rm "$@"


firefox-%: firefox-%.source.tar.xz
	tar xvJf $<


firefox-%/js/src/Makefile: firefox-%
	cd $</js/src/ && ./configure --enable-optimize


libmozjs-%.so: firefox-% firefox-%/js/src/Makefile
	cd $</js/src/ && $(MAKE)
	cp $</js/src/js/src/libmozjs-*.so $@
