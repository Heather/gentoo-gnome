# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libnotify/libnotify-0.4.5.ebuild,v 1.14 2010/03/26 16:28:15 ssuominen Exp $

EAPI="3"

inherit autotools eutils gnome.org

DESCRIPTION="Notifications library"
HOMEPAGE="http://www.galago-project.org/"

LICENSE="LGPL-2.1"
SLOT="0"
# Breaks API, cannot be parallel installed, breaks everything
#KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND=">=dev-libs/glib-2.26:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/gtk-doc-am
	test? ( >=x11-libs/gtk+-2.90:3 )"
PDEPEND="|| (
	x11-misc/notification-daemon
	xfce-extra/xfce4-notifyd
	x11-misc/notify-osd
	>=x11-wm/awesome-3.4.4 )"

src_prepare() {
	default_src_prepare

	# Do not build gtk+:3 tests if unneeded
	epatch "${FILESDIR}/${PN}-0.7.0-gtk3-tests.patch"
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--disable-dependency-tracking \
		$(use_enable test tests)
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS || die "dodoc failed"
}

# Add preserve: /usr/lib64/libnotify.so.1
