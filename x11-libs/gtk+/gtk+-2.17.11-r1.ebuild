# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtk+/gtk+-2.16.5.ebuild,v 1.1 2009/07/19 23:25:17 eva Exp $

EAPI="2"

inherit gnome.org flag-o-matic eutils libtool virtualx

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="cups debug doc jpeg jpeg2k tiff test vim-syntax xinerama"

# FIXME: configure says >=xrandr-1.2.99 but remi tells me it's broken
RDEPEND="x11-libs/libXrender
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXt
	x11-libs/libXext
	>=x11-libs/libXrandr-1.2
	x11-libs/libXcursor
	x11-libs/libXfixes
	x11-libs/libXcomposite
	x11-libs/libXdamage
	xinerama? ( x11-libs/libXinerama )
	>=dev-libs/glib-2.21.3
	>=x11-libs/pango-1.20
	>=dev-libs/atk-1.13
	>=x11-libs/cairo-1.6[X]
	media-libs/fontconfig
	x11-misc/shared-mime-info
	>=media-libs/libpng-1.2.1
	cups? ( net-print/cups )
	jpeg? ( >=media-libs/jpeg-6b-r2 )
	jpeg2k? ( media-libs/jasper )
	tiff? ( >=media-libs/tiff-3.5.7 )
	!<gnome-base/gail-1000"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/inputproto
	x11-proto/damageproto
	xinerama? ( x11-proto/xineramaproto )
	>=dev-util/gtk-doc-am-1.11
	doc? (
		>=dev-util/gtk-doc-1.11
		~app-text/docbook-xml-dtd-4.1.2 )
	test? (
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )"
PDEPEND="vim-syntax? ( app-vim/gtk-syntax )"

set_gtk2_confdir() {
	# An arch specific config directory is used on multilib systems
	has_multilib_profile && GTK2_CONFDIR="/etc/gtk-2.0/${CHOST}"
	GTK2_CONFDIR=${GTK2_CONFDIR:=/etc/gtk-2.0}
}

src_prepare() {
	# use an arch-specific config directory so that 32bit and 64bit versions
	# dont clash on multilib systems
	has_multilib_profile && epatch "${FILESDIR}/${PN}-2.8.0-multilib.patch"

	# Don't break inclusion of gtkclist.h, upstream bug 536767
	epatch "${FILESDIR}/${PN}-2.14.3-limit-gtksignal-includes.patch"

	# Fix blured images when using jpeg7 in gdk-pixbuf, upstream
	# bug #588740, gentoo bug #282744.
	epatch "${FILESDIR}/${PN}-2.16.5-jpeg-backward-compatibility.patch"

	# -O3 and company cause random crashes in applications. Bug #133469
	replace-flags -O3 -O2
	strip-flags

	use ppc64 && append-flags -mminimal-toc

	# Non-working test in gentoo's env
	sed 's:\(g_test_add_func ("/ui-tests/keys-events.*\):/*\1*/:g' \
		-i gtk/tests/testing.c || die "sed 1 failed"
	sed '\%/recent-manager/add%,/recent_manager_purge/ d' \
		-i gtk/tests/recentmanager.c || die "sed 2 failed"
	elibtoolize
}

src_configure() {
	# png always on to display icons (foser)
	local myconf="$(use_enable doc gtk-doc) \
		$(use_with jpeg libjpeg) \
		$(use_with jpeg2k libjasper) \
		$(use_with tiff libtiff) \
		$(use_enable xinerama) \
		$(use_enable cups cups auto) \
		--disable-papi \
		--with-libpng \
		--with-gdktarget=x11 \
		--with-xinput"

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

	set_gtk2_confdir
	dodir ${GTK2_CONFDIR}
	keepdir ${GTK2_CONFDIR}

	# see bug #133241
	echo 'gtk-fallback-icon-theme = "gnome"' > "${D}/${GTK2_CONFDIR}/gtkrc"

	# Enable xft in environment as suggested by <utx@gentoo.org>
	dodir /etc/env.d
	echo "GDK_USE_XFT=1" > "${D}/etc/env.d/50gtk2"

	dodoc AUTHORS ChangeLog* HACKING NEWS* README* || die "dodoc failed"

	# This has to be removed, because it's multilib specific; generated in
	# postinst
	rm "${D}/etc/gtk-2.0/gtk.immodules"
}

pkg_postinst() {
	set_gtk2_confdir

	if [ -d "${ROOT}${GTK2_CONFDIR}" ]; then
		gtk-query-immodules-2.0  > "${ROOT}${GTK2_CONFDIR}/gtk.immodules"
		gdk-pixbuf-query-loaders > "${ROOT}${GTK2_CONFDIR}/gdk-pixbuf.loaders"
	else
		ewarn "The destination path ${ROOT}${GTK2_CONFDIR} doesn't exist;"
		ewarn "to complete the installation of GTK+, please create the"
		ewarn "directory and then manually run:"
		ewarn "  cd ${ROOT}${GTK2_CONFDIR}"
		ewarn "  gtk-query-immodules-2.0  > gtk.immodules"
		ewarn "  gdk-pixbuf-query-loaders > gdk-pixbuf.loaders"
	fi

	if [ -e /usr/lib/gtk-2.0/2.[^1]* ]; then
		elog "You need to rebuild ebuilds that installed into" /usr/lib/gtk-2.0/2.[^1]*
		elog "to do that you can use qfile from portage-utils:"
		elog "emerge -va1 \$(qfile -qC /usr/lib/gtk-2.0/2.[^1]*)"
	fi

	elog "Please install app-text/evince for print preview functionality."
	elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
	elog "add it to your gtkrc."
}
