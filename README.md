Unofficial GNOME overlay [![Build Status](https://travis-ci.org/Heather/gentoo-gnome.png?branch=master)](https://travis-ci.org/Heather/gentoo-gnome)
------------------------

Versions
--------

 - GNOME `3.24.0`
 - Pantheon `live` (so far everything works)

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

Pantheon
--------

 - I used this fix for Super_L key: http://elementaryos.stackexchange.com/questions/1946/have-application-menu-open-up-with-only-windows-key/2083#2083
 - It loads stuff from /usr/share/gnome/autoload either (not sure if I should remove plank from there)

and here is `.xinitrc`

``` shell
#!/bin/sh
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#not sure about block below
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/gnome-settings-daemon/gnome-settings-daemon &
/usr/lib/gnome-user-share/gnome-user-share &
eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

#sometimes pantheon-session also will work
gsettings-data-convert &
xdg-user-dirs-gtk-update &
xrdb merge ~/.Xresources &&
wingpanel &
plank &
exec gala
```

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

same way you can add `conky -d`

Branches
--------

 - `stable` branch was targeting `Sabayon 14.01`
 - `3.16` branch is saved old master
 - `master` branch is for newer stuff based on portage
