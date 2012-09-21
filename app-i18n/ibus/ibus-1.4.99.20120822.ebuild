# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus/ibus-1.4.2.ebuild,v 1.1 2012/08/29 10:30:59 naota Exp $

EAPI="4"
PYTHON_DEPEND="gui? 2:2.5"

inherit eutils gnome2-utils multilib python virtualx

DESCRIPTION="Intelligent Input Bus for Linux / Unix OS"
HOMEPAGE="http://code.google.com/p/ibus/"
SRC_URI="http://ibus.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="dconf doc +gconf gtk gtk3 +introspection nls +gui +python-library test vala +X"
REQUIRED_USE="|| ( gtk gtk3 X ) gui? ( gtk3 )" #342903

COMMON_DEPEND=">=dev-libs/glib-2.26:2
	gnome-base/librsvg:2
	sys-apps/dbus[X?]
	app-text/iso-codes

	dconf? ( >=gnome-base/dconf-0.13.4 )
	gconf? ( >=gnome-base/gconf-2.12:2 )
	gtk? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	X? (
		x11-libs/libX11
		x11-libs/gtk+:2 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.8 )
	nls? ( virtual/libintl )"
RDEPEND="${COMMON_DEPEND}
	gui? (
		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/pango[introspection]
		x11-libs/gtk+:3[introspection] )
	python-library? (
		dev-python/pygtk:2
		>=dev-python/dbus-python-0.83 )"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5.8.1
	dev-util/intltool
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )
	nls? ( >=sys-devel/gettext-0.16.1 )
	vala? ( dev-lang/vala )"
# Vapigen is needed for the vala binding
# Valac is needed when building from git for the engine

# ibus-config test fails
# ERROR:ibus-config.c:302:change_and_test: assertion failed (data->section == expected_section): (NULL == "test/s1")
RESTRICT="test"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	if use python-library || use gui; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_configure() {
	local python valac
	if use python-library || use gui; then
		# We cannot call $(PYTHON) if we haven't called python_pkg_setup
		python="PYTHON=$(PYTHON)"
	fi
	if use vala; then
		vala="VALAC=$(type -P valac-0.18) VAPIGEN=$(type -P vapigen-0.18)"
	fi
	econf \
		$(use_enable dconf) \
		$(use_enable doc gtk-doc) \
		$(use_enable doc gtk-doc-html) \
		$(use_enable introspection) \
		$(use_enable gconf) \
		$(use_enable gtk gtk2) \
		$(use_enable gtk xim) \
		$(use_enable gtk3) \
		$(use_enable gtk3 ui) \
		$(use_enable gtk3 setup) \
		$(use_enable nls) \
		$(use_enable python-library) \
		$(use_enable test tests) \
		$(use_enable vala) \
		$(use_enable X xim) \
		"${python}" \
		"${vala}"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm -f {} +

	insinto /etc/X11/xinit/xinput.d
	newins xinput-ibus ibus.conf

	keepdir /usr/share/ibus/{engine,icons} #289547
}

pkg_preinst() {
	use gconf && gnome2_gconf_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	use gconf && gnome2_gconf_install
	use gtk && gnome2_query_immmodules_gtk2
	use gtk3 && gnome2_query_immmodules_gtk3
	#use python-library && python_mod_optimize /usr/share/${PN}
	gnome2_icon_cache_update

	elog "To use ibus, you should:"
	elog "1. Get input engines from sunrise overlay."
	elog "   Run \"emerge -s ibus-\" in your favorite terminal"
	elog "   for a list of packages we already have."
	elog
	elog "2. Setup ibus:"
	elog
	elog "   $ ibus-setup"
	elog
	elog "3. Set the following in your user startup scripts"
	elog "   such as .xinitrc, .xsession or .xprofile:"
	elog
	elog "   export XMODIFIERS=\"@im=ibus\""
	elog "   export GTK_IM_MODULE=\"ibus\""
	elog "   export QT_IM_MODULE=\"xim\""
	elog "   ibus-daemon -d -x"
}

pkg_postrm() {
	use gtk && gnome2_query_immmodules_gtk2
	use gtk3 && gnome2_query_immmodules_gtk3
	#use python && python_mod_cleanup /usr/share/${PN}
	gnome2_icon_cache_update
}
