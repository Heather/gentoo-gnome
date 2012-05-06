# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gnome-disk-utility/gnome-disk-utility-2.32.0.ebuild,v 1.3 2011/01/07 21:04:46 pacho Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Disk Utility for GNOME using devicekit-disks"
HOMEPAGE="http://git.gnome.org/browse/gnome-disk-utility"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="avahi doc fat gnome-keyring nautilus remote-access"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
fi

CDEPEND="
	>=dev-libs/glib-2.22:2
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/libunique-2.90.1:3
	>=x11-libs/gtk+-2.90.7:3
	=sys-fs/udisks-1.0*[remote-access?]
	>=dev-libs/libatasmart-0.14
	>=x11-libs/libnotify-0.6.1

	avahi? ( >=net-dns/avahi-0.6.25[gtk3] )
	gnome-keyring? ( || (
		gnome-base/libgnome-keyring
		<gnome-base/gnome-keyring-2.29.4 ) )
	nautilus? ( >=gnome-base/nautilus-2.91.0 )
"
RDEPEND="${CDEPEND}
	x11-misc/xdg-utils
	fat? ( sys-fs/dosfstools )
	!!sys-apps/udisks"
DEPEND="${CDEPEND}
	sys-devel/gettext
	gnome-base/gnome-common
	app-text/docbook-xml-dtd:4.1.2
	app-text/scrollkeeper
	app-text/gnome-doc-utils

	>=dev-util/intltool-0.35
	virtual/pkgconfig
	>=dev-util/gtk-doc-am-1.13

	doc? ( >=dev-util/gtk-doc-1.3 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable avahi avahi-ui)
		$(use_enable nautilus)
		$(use_enable remote-access)
		$(use_enable gnome-keyring)"
	DOCS="AUTHORS NEWS README TODO"
}

src_prepare() {
	sed -e '/printf/s:nautilus:xdg-open:' \
		-i src/palimpsest/gdu-section-volumes.c || die "#350919"

	# Keep avahi optional, upstream bug #631986
	epatch "${FILESDIR}/${PN}-2.91.6-optional-avahi.patch"

	if [[ ${PV} != 9999 ]]; then
		intltoolize --force --copy --automake || die
		eautoreconf
	fi

	gnome2_src_prepare
}
