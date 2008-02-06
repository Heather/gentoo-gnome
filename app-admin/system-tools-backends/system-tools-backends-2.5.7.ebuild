# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/system-tools-backends/system-tools-backends-2.4.2.ebuild,v 1.1 2008/01/24 23:05:37 eva Exp $

inherit gnome2 eutils

DESCRIPTION="Tools aimed to make easy the administration of UNIX systems"
HOMEPAGE="http://www.gnome.org/projects/gst/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!<app-admin/gnome-system-tools-1.1.91
		>=sys-apps/dbus-1.1.2
		>=dev-libs/dbus-glib-0.74
		>=dev-libs/glib-2.15.2
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

src_compile() {
	# Autotools insanity, localstatedir gets set to /usr/local/var by default
	gnome2_src_compile --localstatedir="${ROOT}"/var
}

src_install() {
	gnome2_src_install
	newinitd "${FILESDIR}"/stb.rc system-tools-backends
}

pkg_postinst() {
	echo
	elog "You need to add yourself to the group stb-admin and"
	elog "add system-tools-backends to the default runlevel."
	elog "You can do this as root like so:"
	elog "  # rc-update add system-tools-backends default"
	echo
}
