# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnome-python-desktop/gnome-python-desktop-2.24.1.ebuild,v 1.2 2009/02/05 20:16:32 aballier Exp $

DESCRIPTION="Meta build which provides python interfacing modules for some GNOME desktop libraries"
HOMEPAGE="http://pygtk.org/"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="~dev-python/bug-buddy-python-${PV}
	~dev-python/evolution-python-${PV}
	~dev-python/gnome-applets-python-${PV}
	~dev-python/gnome-desktop-python-${PV}
	~dev-python/gnome-keyring-python-${PV}
	~dev-python/gnome-media-python-${PV}
	~dev-python/gtksourceview-python-${PV}
	~dev-python/libgnomeprint-python-${PV}
	~dev-python/libgtop-python-${PV}
	~dev-python/librsvg-python-${PV}
	~dev-python/libwnck-python-${PV}
	~dev-python/metacity-python-${PV}
	~dev-python/nautilus-cd-burner-python-${PV}
	~dev-python/totem-python-${PV}"
