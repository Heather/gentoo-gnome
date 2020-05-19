Unofficial GNOME overlay
[![Build Status](https://travis-ci.org/Heather/gentoo-gnome.png?branch=master)](https://travis-ci.org/Heather/gentoo-gnome)
[![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/Heather/gentoo-gnome.svg)](http://isitmaintained.com/project/Heather/gentoo-gnome "Average time to resolve an issue")
[![Percentage of issues still open](http://isitmaintained.com/badge/open/Heather/gentoo-gnome.svg)](http://isitmaintained.com/project/Heather/gentoo-gnome "Percentage of issues still open")
[![Twitter][]](http://www.twitter.com/Cynede)
------------------------

Versions
--------

 - GNOME `~3.36/37.x`
 - Pantheon `Juno` ebuilds

Communication
-------------

 - [![Gentoo discord server](https://img.shields.io/discord/249111029668249601.svg?style=flat-square&label=Gentoo%20Linux)](https://discord.gg/Gentoo)
 - [issues](https://github.com/Heather/gentoo-gnome/issues)

Major differences with the main tree
-------------------------

 - To use the latest versions of vala, mask the old vala version to see the limitations. Currently, the only way to use the new vala is to port everything to this overlay.

Information
-----------
 - `list.py` lists packages inside the overlay and their versions.
 - The official [gnome overlay](http://git.overlays.gentoo.org/gitweb/?p=proj/gnome.git;a=summary).
 - Contributions are welcome.
 - For bugs, use [GitHub issues](https://github.com/Heather/gentoo-gnome/issues?state=open).
 - Use `pull --rebase` to resolve conflicts or set `branch.autosetuprebase = always`.
 - [This script](https://github.com/Heather/gentoo-gnome/blob/master/compare.py) removes features implemented upstream from this overlay.

Pantheon
--------
minimal installation:
 - pantheon-shell (excludes wingpanel-indicators, switchboard-plugs)

full installation:
 - pantheon-meta
 - USE="minimal" excludes elementary-apps (default +minimal)
 - bluetooth the section is not checked
 - switchboard-plug-locale the plugin is tied to the Ubuntu. ideally, it should be rewritten. It's useless now
 - switchboard-plug-useraccounts a little unfinished. it is tied to the accountsservice with patches from Debian. But these patches are not yet in gentoo.

(Dirli's cooment: below is written by someone else, left it, suddenly someone come in handy)
 - Entries from `/usr/share/gnome/autostart` are loaded.

Here is an example `.xinitrc`:

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

Autostarting Plank in GNOME
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

Likewise, `conky -d` can be added.

Branches
--------

 - `stable` branch was targeting `Sabayon 14.01`
 - `3.16` branch is saved old master
 - `master` branch is for newer stuff based on portage

[Twitter]: http://mxtoolbox.com/Public/images/twitter-icon.png
