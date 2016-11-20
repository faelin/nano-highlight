nanorc syntax highlighting project
==================================

Description
-----------

The syntax highlighting definitions that come bundled with nano are of pretty poor quality. This is an attempt at providing a good set of accurate syntax definitions to replace and expand the defaults, as well as provide standards for syntax highlighting across file types. This project 
is originally based on [Thomas McCarthy's nano-highlight](https://github.com/twmccart/nano-highlight), which is in turn based on the earlier [nanorc-mac](https://github.com/richrad/nanorc-mac) project.

Also included is a simple theming system, where all `color` statements (e.g. `color brightred`) have been replaced with token identifiers (e.g. `KEYWORD`, `OPERATOR`). These are replaced with colors according to the chosen theme at build time. This system helps to keep colors uniform accross different languages and also to keep the definitions clear and maintainable.

Here is a brief list of what supported formats changed in this repository compared to the source one.

### Added language highlighting

  * Asterisk PBX configuration (both .conf and .ael)
  * CronTab
  * DM
  * Erlang
  * LogRotate configuration files
  * NanorcTheme (theme files used in this project)
  * /etc/group, /etc/passwd, /etc/shadow

### Improved highlighting themes

  * CSS
  * HTML
  * Nano configuration / syntax highlighting rules
  * Nginx configuration files
  * ColorTest (bogus format for testing color themes)

### Minor improvements

  * JavaScript scripts
  * Markdown texts
  * Shell scripts

Installation
------------

Using `make install` will install the syntax definitions to the
`~/.nano/syntax/` directory.

To enable highlighting for *all* languages after installation, add the
following command to your `~/.nanorc` file:

    include ~/.nano/syntax/ALL.nanorc

To enable only a subset of languages, `include` them individually:

    include ~/.nano/syntax/c.nanorc
    include ~/.nano/syntax/python.nanorc
    include ~/.nano/syntax/sh.nanorc
    # ...

If you prefer to install to a location that all users can access, using
`sudo make install-global` will install to `/usr/local/share/nano/`.
Syntax files installed under this directory can then be `include`d in
either `/etc/nanorc` or any user's personal `~/.nanorc`.

**Note**: If your terminal **text** color isn't white, you'll need to
specify it when installing, using `make install TEXT=color`, where
`color` must be one of: `red`, `green`, `yellow`, `blue`, `magenta`,
`cyan` or `black`. These nanorc files are designed for editing files on
a console, which is usually black with white text. If you have a GUI,
you probably shouldn't be using nano.

After installation, the various source code samples in the [examples]/
directory can be used to check that highlighting is working correctly.
If it doesn't work as expected, see the FAQ below.

Theme System
------------

All `*.nanorc` files are passed through [mixins.sed] found in the [scripts]/
directory, and additionally through a theme-definition system
([default.nanorctheme] by default) before installation. This system allows
rules to be specified in terms of token type names or [mixins], instead
of hard-coded colors.

For example, the following named rule:

    TYPE: "int|bool|string"

becomes:

    color brightblue "int|bool|string"

and the following "mixin":

    +BOOLEAN

becomes:

    color brightwhite "\<(true|false)\>"

This system helps to keep colors uniform across different languages and
also to keep the definitions clear and maintainable, which is something that
becomes quite awkward using only plain [nanorc] files.

**Note:** if `~/.nanorctheme` exists, it will be used as a custom theme, in
place of [default.nanorctheme]. A custom theme may also be specified by copying
the theme-definition file in [themes]/ directory first, and then installing
with `make THEME=your-custom-theme` (note that you do not need to specify
the path to a file, neither do you need to specify file's extension). To find
out how themes are defined, have a look at the default theme (file
[default.nanorctheme]). You must define *all* token types found in that file
in order for syntax highlighting to work correctly with your custom theme. Bear
in mind that the format of the theme-definition file has changed compared
to the format used in source repositories (it used to be a sed script, while
now such script is automatically generated from the chosen theme-definition
file during the build process).

**Note 2:** don't forget that if you execute `make` via `sudo` (e.g. to install
global syntax highlighting rules as outlined above), then `~/.nanorctheme` will
refer to a file in root's home directory, not your own.

FAQ
----

### Why does syntax highlighting only work for a subset of supported files?

There appears to be a bug in older versions of nano that causes
highlighting to fail when `/etc/nanorc` and `~/.nanorc` both contain
`syntax` rules. The usual workaround is to remove all `syntax` and `include`
commands from one file or the other, or to use a newer version of nano.

### Why do I get weird errors when running nano < 2.1.5 on *BSD systems?

In order to reliably highlight keywords, this projects makes heavy use of
the GNU regex word boundary extensions (`\<` and `\>`). BSD implementations
also have these extensions but use a different, incompatible syntax
(`[[:<:]]` and `[[:>:]]`). Since version 2.1.5, nano can automatically
translate the GNU syntax to BSD syntax at run-time, but for the benefit of
people running a pre-2.1.5 version of nano on OS X or *BSD, the `.nanorc`
file itself can be translated by installing with `make BSDREGEX=1`.

### Why not use `\s` instead of the verbose `[[:space:]]` pattern?

Because nano compiles against the platform's native regex library and some
platforms don't support `\s` (as it's not required by POSIX [ERE]).

License
-------

To the extent possible under law, the author(s) have dedicated all copyright
and related and neighboring rights to this software to the public domain
worldwide. This software is distributed without any warranty.

You should have received a copy of the CC0 Public Domain Dedication along
with this software. If not, you can download it from [their website][CC0].

[nanorc]: http://www.nano-editor.org/dist/v2.3/nanorc.5.html
[default.nanorctheme]: https://github.com/YSakhno/nanorc/tree/master/themes/default.nanorctheme
[mixins.sed]: https://github.com/YSakhno/nanorc/tree/master/scripts/mixins.sed
[examples]: https://github.com/YSakhno/nanorc/tree/master/examples
[mixins]: https://github.com/YSakhno/nanorc/tree/master/mixins
[scripts]: https://github.com/YSakhno/nanorc/tree/master/scripts
[themes]: https://github.com/YSakhno/nanorc/tree/master/themes
[ERE]: http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap09.html#tag_09_04
[CC0]: https://creativecommons.org/publicdomain/zero/1.0/
