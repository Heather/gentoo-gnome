Unofficial GNOME overlay [![Build Status](https://travis-ci.org/Heather/gentoo-gnome.png?branch=master)](https://travis-ci.org/Heather/gentoo-gnome)
------------------------

!!! Absolutely working, everyone is welcome for test/feedback !!!
=================================================================

 - current stage is `3.23.90`
 - use `compare.py` script to update this overlay on top of official
 - `list.py` to list packages inside overlay with versions
 - official gnome overlay: http://git.overlays.gentoo.org/gitweb/?p=proj/gnome.git;a=summary
 - contributors are still welcome.
 - For bugs use GitHub issues https://github.com/Heather/gentoo-gnome/issues?state=open
 - Please use `pull --rebase` to resolve conflicts or set `branch.autosetuprebase = always`
 - This overlay is NOT available via `layman` currently
 - this script removes implemented upstream things from this overlay https://github.com/Heather/gentoo-gnome/blob/master/compare.py

Branches
--------

 - `stable` branch was targeting `Sabayon 14.01`
 - `3.16` branch is saved old master
 - `master` branch is for newer stuff based on portage

TODO
----

 - optional wacom (but I'm really lazy for it)
