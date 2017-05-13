firefox-%.source.tar.xz:
	wget "https://archive.mozilla.org/pub/firefox/releases/$(patsubst firefox-%.source.tar.xz,%,$@)/source/$@" -O "$@" || rm "$@"


firefox-%: firefox-%.source.tar.xz
	tar xvJf $<


firefox-%/js/src/Makefile: firefox-%
	cd $</js/src/ && ./configure --enable-optimize


firefox-%/js/src/js/src/libmozjs-%.so: firefox-% firefox-%/js/src/Makefile
	cd $</js/src/ && $(MAKE)
	cd $</js/src/js/src/ && cp libmozjs-*.so libmozjs-%.so


libmozjs-%.so: firefox-%/js/src/js/src/libmozjs-%.so
	cp $< $@
