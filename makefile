ifndef version
$(error version is undefined)
endif


ifdef debug
CONFIG_OPTIONS = --disable-optimize --enable-debug --disable-shared-js
else
CONFIG_OPTIONS = --enable-optimize --disable-shared-js
endif
FIREFOX_SRC_URL = https://archive.mozilla.org/pub/firefox/releases/$(version)/source/firefox-$(version).source.tar.xz
JS_SRC_DIR = firefox-$(version)/js/src

short_version = $(firstword $(subst ., ,$(version)))

static_libs = $(shell find firefox-$(version)/js/src | grep 'build/.*\.a$$') firefox-$(version)/js/src/js/src/libjs_static.a


.PHONY: default
default: $(JS_SRC_DIR)/Makefile
	cd "$(JS_SRC_DIR)" && $(MAKE) && $(MAKE) install "prefix=$(realpath .)"
	g++ -fPIC -shared -Wl,--whole-archive $(static_libs) -Wl,--no-whole-archive -lpthread -o lib/libmozjs-$(short_version).so


.PHONY: install
install: $(JS_SRC_DIR)/Makefile
	cd "$(JS_SRC_DIR)" && $(MAKE) install
	cp lib/libmozjs-$(short_version).so /usr/local/lib/


firefox-$(version).source.tar.xz:
	wget "$(FIREFOX_SRC_URL)" -O "$@" && touch "$@"


$(JS_SRC_DIR)/configure: firefox-$(version).source.tar.xz
	tar xvJf "$<" && touch "$@"


$(JS_SRC_DIR)/Makefile: $(JS_SRC_DIR)/configure
	cd "$(JS_SRC_DIR)" && ./configure $(CONFIG_OPTIONS)
