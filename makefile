ifndef version
$(error version is undefined)
endif


FIREFOX_SRC_URL:=https://archive.mozilla.org/pub/firefox/releases/$(version)/source/firefox-$(version).source.tar.xz
JS_SRC_DIR:=firefox-$(version)/js/src


.PHONY: default
default: $(JS_SRC_DIR)/Makefile
	cd "$(JS_SRC_DIR)" && $(MAKE) && $(MAKE) install "prefix=$(realpath .)"


.PHONY: install
install: $(JS_SRC_DIR)/Makefile
	cd "$(JS_SRC_DIR)" && $(MAKE) install


firefox-$(version).source.tar.xz:
	wget "$(FIREFOX_SRC_URL)" -O "$@" && touch "$@"


$(JS_SRC_DIR)/configure: firefox-$(version).source.tar.xz
	tar xvJf "$<" && touch "$@"


$(JS_SRC_DIR)/Makefile: $(JS_SRC_DIR)/configure
	cd "$(JS_SRC_DIR)" && ./configure --enable-optimize
