Unofficial GNOME overlay [![Build Status](https://travis-ci.org/Heather/gentoo-gnome.png?branch=master)](https://travis-ci.org/Heather/gentoo-gnome)
------------------------

 - current stage is `3.22.2`
 - mutter needs `ln -s /usr/lib64/mutter/lib*.so /usr/lib64` https://bugzilla.gnome.org/show_bug.cgi?id=768781
 - there is some problem with gnome builder but it works w/o sandbox `FEATURES="-sandbox -usersandbox" emerge -av gnome-builder`
 - use `compare.py` script to update this overlay on top of official
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
 - `master` branch is for newer stuff based on `gnome` overlay

TODO
----

 - fix mutter/gnome-shell hacks (maybe add symlinks) (they've got patch somewhere)
 - gnome control center needs gtk+ from git
 - optional wacom
