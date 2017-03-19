Unofficial GNOME overlay [![Build Status](https://travis-ci.org/Heather/gentoo-gnome.png?branch=master)](https://travis-ci.org/Heather/gentoo-gnome)
------------------------

Versions
--------

 - GNOME `3.23.92`
 - cinnamon `3.2.8`
 - Plank/Wingpanel/Gala from Pantheon `live` ebuilds
 - experimental plank-shell stuff

Known problems
--------------

 - mutter will possibly fail without wayland support
 - wacom is not really optional for now
 - as for me it seems like gnome-shell leaks a bit, needs more testing
 - on one (from three) setup first time gnome-session always crashes but then works stable, needs debugging

Information
-----------

 - use `compare.py` script to update this overlay on top of official
 - `list.py` to list packages inside overlay with versions
 - official gnome overlay: http://git.overlays.gentoo.org/gitweb/?p=proj/gnome.git;a=summary
 - contributors are still welcome.
 - For bugs use GitHub issues https://github.com/Heather/gentoo-gnome/issues?state=open
 - Please use `pull --rebase` to resolve conflicts or set `branch.autosetuprebase = always`
 - This overlay is NOT available via `layman` currently
 - this script removes implemented upstream things from this overlay https://github.com/Heather/gentoo-gnome/blob/master/compare.py

Plank to autostart in GNOME
---------------------------

add `/usr/share/gnome/autostart/plank.desktop`
```
[Desktop Entry]
Type=Application
Name=Plank
Comment=Plank panel
Exec=/usr/bin/plank
OnlyShowIn=GNOME;
X-GNOME-Autostart-Phase=Application
```

Branches
--------

 - `stable` branch was targeting `Sabayon 14.01`
 - `3.16` branch is saved old master
 - `master` branch is for newer stuff based on portage
