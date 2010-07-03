# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtk+/gtk+-2.20.1-r1.ebuild,v 1.2 2010/06/20 11:15:18 nirbheek Exp $

EAPI="3"

inherit gnome.org flag-o-matic multilib libtool virtualx

DESCRIPTION="Image loading library for GTK+"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug doc +introspection jpeg jpeg2k tiff test"

RDEPEND="
	>=dev-libs/glib-2.25.9
	>=media-libs/libpng-1.2.43-r2:0
	jpeg? ( >=media-libs/jpeg-6b-r9:0 )
	jpeg2k? ( media-libs/jasper )
	tiff? ( >=media-libs/tiff-3.9.2 )
	!<gnome-base/gail-1000
	!<x11-libs/gtk+-2.21.3:2
	!<x11-libs/gtk+-2.90.4:3"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=sys-devel/gettext-0.17
	x86-interix? (
		sys-libs/itx-bind
	)
	>=dev-util/gtk-doc-am-1.11
	doc? (
		>=dev-util/gtk-doc-1.11
		~app-text/docbook-xml-dtd-4.1.2 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-readd-deprecated-apis.patch

	elibtoolize
}

src_configure() {
	# -O3 and company cause random crashes in applications. Bug #133469
	replace-flags -O3 -O2
	strip-flags

	use ppc64 && append-flags -mminimal-toc

	if use x86-interix; then
		# activate the itx-bind package...
		append-flags "-I${EPREFIX}/usr/include/bind"
		append-ldflags "-L${EPREFIX}/usr/lib/bind"
	fi

	# png always on to display icons (foser)
	local myconf="
		$(use_enable doc gtk-doc)
		$(use_with jpeg libjpeg)
		$(use_with jpeg2k libjasper)
		$(use_with tiff libtiff)
		$(use_enable introspection)
		--with-libpng"

	# Passing --disable-debug is not recommended for production use
	use debug && myconf="${myconf} --enable-debug=yes"

	econf ${myconf}
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "tests failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS NEWS* README* || die "dodoc failed"
}

pkg_postinst() {
	gdk-pixbuf-query-loaders > "${EROOT}usr/$(get_libdir)/gdk-pixbuf-2.0/2.10.0/loaders.cache"

	if [ -e "${EROOT}"usr/lib/gtk-2.0/2.*/loaders ]; then
		elog "You need to rebuild ebuilds that installed into" "${EROOT}"usr/lib/gtk-2.0/2.*/loaders
		elog "to do that you can use qfile from portage-utils:"
		elog "emerge -va1 \$(qfile -qC ${EPREFIX}/usr/lib/gtk-2.0/2.*/loaders)"
	fi
}
