# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/policykit-gnome/policykit-gnome-0.9.2-r1.ebuild,v 1.6 2009/07/02 19:41:46 aballier Exp $

EAPI="2"

inherit gnome2 eutils

DESCRIPTION="PolicyKit policies and configurations for the GNOME desktop"
HOMEPAGE="http://hal.freedesktop.org/docs/PolicyKit"
SRC_URI="http://hal.freedesktop.org/releases/${P}.tar.bz2"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc examples"

RDEPEND=">=x11-libs/gtk+-2.17.1
	>=gnome-base/gconf-2.8
	>=dev-libs/dbus-glib-0.71
	>=sys-auth/polkit-0.93"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.19
	>=dev-util/intltool-0.35.0
	>=app-text/scrollkeeper-0.3.14
	doc? ( >=dev-util/gtk-doc-1.3 )"

DOCS="AUTHORS HACKING NEWS TODO"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable examples)"
}
