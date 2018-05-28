# antcheck

This is currently in development.

A C program for identifying potentially anticipated #2 chess problems in my Meson Chess
Problem Database (http://www.bstephen.me.uk/meson/meson.pl). Not useful for anybody but
me. It is a rewrite of a Perl script that, with the increase in size of the
database, is taking too long to run.

It runs on Linux and uses the standard pthread, ncurses and mysqlclient C libraries.

It also uses the following external open source libraries:

Mini-XML by Michael Sweet (michaelrsweet/mxml here on Github).
UThash, UTarray and UTstring by Troy Hanson (troydhanson/uthash here on Github).