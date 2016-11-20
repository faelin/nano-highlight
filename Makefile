LANGS  = apacheconf asm asteriskael asteriskconf awk c cmake coffeescript \
         colortest crontab csharp css cython default diff dm dot email erlang \
         etcgroup etcpasswd etcshadow git glsl go html ini inputrc java \
         javascript json keymap kickstart ledger lisp logrotate lua makefile \
         man markdown mpdconf nanorc nanorctheme nginx patch peg perl php \
         pkg-config pkgbuild po privoxy properties python R rpmspec ruby sed \
         shell sql systemd tex vala vi xml xresources yaml yum

MIXINS = $(wildcard mixins/*.nanorc)
FILES  = $(addsuffix .nanorc, $(LANGS))
ALL    = $(addprefix build/, $(FILES)) build/ALL.nanorc
DIR    = $(HOME)/.nano/syntax
THEME  = default
FILTER = sed -f scripts/mixins.sed | sed -f build/theme.sed

THEME_FILE = themes/$(THEME).nanorctheme


all: $(ALL)

build/theme.sed: $(THEME_FILE) | build/
	@sed -f scripts/compile-theme.sed $(THEME_FILE) > build/theme.sed

build/ALL.nanorc: $(FILES) $(MIXINS) | build/theme.sed
	@echo '# This is an autogenerated file for syntax highlighting' > $@
	@echo '# in Nano. Do not edit this file by hand, as your changes' >> $@
	@echo '# might be overwritten next time this file is re-generated.' >> $@
	@echo '# Instead, create a new nanorc highlighting file and make' >> $@
	@echo '# changes there, then run make again.' >> $@
	@echo '' >> $@
	@cat $(FILES) | $(FILTER) >> $@
	@echo 'Generated: $@'

build/%.nanorc: %.nanorc $(MIXINS) | build/theme.sed
	@echo '# This file was automatically generated from $<' > $@
	@echo '' >> $@
	@cat $< | $(FILTER) > $@
	@echo 'Generated: $@'

build/:
	@mkdir -p $@

install: all
	@mkdir -p '$(DESTDIR)$(DIR)'
	@install -p -m 0644 $(ALL) '$(DESTDIR)$(DIR)'
	@echo 'Installed: $(DESTDIR)$(DIR)/*.nanorc'

install-global:
	@$(MAKE) --no-print-directory install DIR=/usr/local/share/nano

clean:
	@echo 'Cleaning...'
	rm -rf build


ifeq ($(shell test -f ~/.nanorctheme && echo 1),1)
  THEME_FILE = ~/.nanorctheme
endif

# Remove "header" directives if not supported (introduced in nano 2.1.6)
NANOVER = $(shell nano -V | sed -n 's/^.* version \([0-9\.]*\).*/\1/p')
ifeq ($(shell printf "2.1.5\n$(NANOVER)" | sort -nr | head -1),2.1.5)
  FILTER += | sed -e '/^header/d'
endif

#Remove "magic" command if not supported (introduced in 2.3)

#Extract just the minor version.
NANOMINORVER = $(shell nano -V | sed -n 's/^.* version \([0-9\.]*\)\..*/\1/p')

SUPPORTMAGIC = $(shell expr $(NANOMINORVER) \>= 2.3)

ifeq ($(SUPPORTMAGIC),0)
  FILTER += | sed -e '/^magic/d'
endif

ifdef TEXT
  FILTER += | sed -e 's/^\(i\)\{0,1\}color \(bright\)\{0,1\}white/\1color \2$(TEXT)/'
endif

ifdef BSDREGEX
  FILTER += | sed -e 's|\\<|[[:<:]]|g;s|\\>|[[:>:]]|g'
endif


.PHONY: all install install-global clean force
