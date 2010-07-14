# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="http://www.gnome.org/projects/evince/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris"

IUSE="dbus debug djvu doc dvi gnome gnome-keyring +introspection nautilus t1lib tiff"

# Since 2.26.2, can handle poppler without cairo support. Make it optional ?
# not mature enough
RDEPEND="
	>=app-text/libspectre-0.2.0
	>=dev-libs/glib-2.25.11
	>=dev-libs/libxml2-2.5
	>=x11-libs/gtk+-2.90.5:3[introspection?]
	>=x11-libs/libSM-1
	>=x11-themes/gnome-icon-theme-2.17.1
	gnome? ( >=gnome-base/gconf-2[introspection?] )
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.22.0 )
	nautilus? ( >=gnome-base/nautilus-2.10[introspection?] )
	>=app-text/poppler-0.14[cairo]
	dvi? (
		virtual/tex-base
		t1lib? ( >=media-libs/t1lib-5.0.0 ) )
	tiff? ( >=media-libs/tiff-3.6 )
	djvu? ( >=app-text/djvu-3.5.17 )
	introspection? ( >=dev-libs/gobject-introspection-0.6 )"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.3.2
	~app-text/docbook-xml-dtd-4.1.2
	>=dev-util/pkgconfig-0.9
	sys-devel/gettext
	>=dev-util/intltool-0.35
	dev-util/gtk-doc-am
	doc? ( dev-util/gtk-doc )"

DOCS="AUTHORS ChangeLog NEWS README TODO"
ELTCONF="--portage"

# Needs dogtail and pyspi from http://fedorahosted.org/dogtail/
# Releases: http://people.redhat.com/zcerza/dogtail/releases/
RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-static
		--disable-tests
		--enable-pdf
		--enable-comics
		--enable-impress
		--enable-thumbnailer
		--with-smclient=xsmp
		--with-platform=gnome
		$(use_enable dbus)
		$(use_enable djvu)
		$(use_enable dvi)
		$(use_with gnome gconf)
		$(use_with gnome-keyring keyring)
		$(use_enable t1lib)
		$(use_enable tiff)
		$(use_enable nautilus)
		$(use_enable introspection)"
}

src_prepare() {
	gnome2_src_prepare

	# Fix .desktop file so menu item shows up
	epatch "${FILESDIR}"/${PN}-0.7.1-display-menu.patch
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}
