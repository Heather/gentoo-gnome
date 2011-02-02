# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-session/gnome-session-2.32.1.ebuild,v 1.4 2011/01/03 11:41:21 pacho Exp $

EAPI="3"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2

DESCRIPTION="Gnome session manager"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
IUSE="doc ipv6 elibc_FreeBSD"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
fi

COMMON_DEPEND=">=dev-libs/glib-2.16:2
	>=x11-libs/gtk+-2.90.7:3
	>=dev-libs/dbus-glib-0.76
	>=gnome-base/gconf-2
	>=sys-power/upower-0.9.0
	elibc_FreeBSD? ( dev-libs/libexecinfo )

	virtual/opengl
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXtst
	x11-apps/xdpyinfo"
# Pure-runtime deps from the session files
# Don't add nautilus because that has been removed in trunk
# gnome-panel is used by classic-gnome
RDEPEND="${COMMON_DEPEND}
	gnome-base/gnome-panel
	gnome-base/gnome-settings-daemon
	gnome-base/gnome-shell"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=sys-devel/gettext-0.10.40
	>=dev-util/pkgconfig-0.17
	>=dev-util/intltool-0.40
	!<gnome-base/gdm-2.20.4
	doc? (
		app-text/xmlto
		dev-libs/libxslt )"
# gnome-base/gdm does not provide gnome.desktop anymore

pkg_setup() {
	# TODO: convert libnotify to a configure option
	G2CONF="${G2CONF}
		--disable-deprecation-flags
		--disable-maintainer-mode
		--disable-schemas-compile
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--with-gtk=3.0
		$(use_enable doc docbook-docs)
		$(use_enable ipv6)"
	DOCS="AUTHORS ChangeLog NEWS README"

	# Add "session saving" button back, upstream bug #575544
	epatch "${FILESDIR}/${PN}-2.32.0-session-saving-button.patch"

	if [[ ${PV} != 9999 ]]; then
		intltoolize --force --copy --automake || die "intltoolize failed"
		eautoreconf
	fi

	gnome2_src_prepare
}

src_install() {
	gnome2_src_install

	dodir /etc/X11/Sessions || die "dodir failed"
	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/Gnome" || die "doexe failed"
}
