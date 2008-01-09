# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 eutils

DESCRIPTION="Tools aimed to make easy the administration of UNIX systems"
HOMEPAGE="http://www.gnome.org/projects/gst/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!<app-admin/gnome-system-tools-1.1.91
		>=dev-libs/glib-2.4
		>=dev-libs/dbus-glib-0.71
		>=dev-perl/Net-DBus-0.33.4
		dev-lang/perl
		userland_GNU? ( sys-apps/shadow )"

DEPEND="${RDEPEND}
		dev-util/pkgconfig
		>=dev-util/intltool-0.29"

DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README TODO"

pkg_setup() {
	enewgroup stb-admin || die "Failed to create stb-admin group"
}

src_unpack() {
	gnome2_src_unpack
	# Fix baselayout-2 problems with services-admin
	epatch "${FILESDIR}"/${P}-baselayout2.patch
}

src_compile() {
	# Autotools insanity, localstatedir gets set to /usr/local/var by default
	gnome2_src_compile --localstatedir="${ROOT}"/var
}

src_install() {
	gnome2_src_install
	newinitd "${FILESDIR}"/stb.rc system-tools-backends
}

pkg_postinst() {
	elog "You need to add yourself to the group stb-admin"
	elog "At this time, you won't be able to change anything"
	elog "and don't try it, it will only make dbus crash"
	elog "You have been warned !"
	elog ""
	elog "If you still feel like trying it, start system-tools-backends with"
	elog "/etc/init.d/system-tools-backends start, only then you should be"
	elog "able to touch configuration"
}
