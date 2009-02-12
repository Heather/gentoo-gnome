# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-panel/gnome-panel-2.24.3.ebuild,v 1.3 2009/02/05 19:25:25 aballier Exp $

GCONF_DEBUG="no"

inherit autotools gnome2

MY_P="${PN}-2.24.2"
DESCRIPTION="The GNOME panel"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${SRC_URI}
	mirror://gentoo/${MY_P}-logout+po.tar.bz2"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc eds networkmanager"

RDEPEND=">=gnome-base/gnome-desktop-2.12
	>=x11-libs/pango-1.15.4
	>=dev-libs/glib-2.16.0
	>=x11-libs/gtk+-2.13.1
	>=dev-libs/libgweather-2.24.1
	dev-libs/libxml2
	>=gnome-base/libglade-2.5
	>=gnome-base/libgnome-2.13
	>=gnome-base/libgnomeui-2.5.4
	>=gnome-base/libbonoboui-2.1.1
	>=gnome-base/orbit-2.4
	>=x11-libs/libwnck-2.19.5
	>=gnome-base/gconf-2.6.1
	>=gnome-base/gnome-menus-2.11.1
	>=gnome-base/libbonobo-2.20.4
	gnome-base/librsvg
	>=dev-libs/dbus-glib-0.71
	>=sys-apps/dbus-1.1.2
	x11-libs/libXau
	>=x11-libs/cairo-1.0.0
	eds? ( >=gnome-extra/evolution-data-server-1.6 )
	networkmanager? ( >=net-misc/networkmanager-0.6 )"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	~app-text/docbook-xml-dtd-4.1.2
	>=dev-util/gtk-doc-am-1
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-schemas-install
		--with-in-process-applets=clock,notification-area,wncklet
		--disable-polkit
		$(use_enable networkmanager network-manager)
		$(use_enable eds)"
}

src_unpack() {
	gnome2_src_unpack

	# Allow logout/shutdown without gnome-session 2.24, bug #246170
	epatch "${WORKDIR}/${MY_P}-logout.patch"
	# FIXME FIXME FIXME: This patch doesn't apply.
	#epatch "${WORKDIR}/${MY_P}-po.patch"
	# Fixes build on BSD, bug #256859
	epatch "${FILESDIR}/${PN}-2.24.3-daylight.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautomake
}

pkg_postinst() {
	local entries="${ROOT}etc/gconf/schemas/panel-default-setup.entries"
	local gconftool="${ROOT}usr/bin/gconftool-2"

	if [ -e "$entries" ]; then
		einfo "setting panel gconf defaults..."

		GCONF_CONFIG_SOURCE="$("${gconftool}" --get-default-source | sed "s;:/;:${ROOT};")"

		"${gconftool}" --direct --config-source \
			"${GCONF_CONFIG_SOURCE}" --load="${entries}"
	fi

	# Calling this late so it doesn't process the GConf schemas file we already
	# took care of.
	gnome2_pkg_postinst
}
