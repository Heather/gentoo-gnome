# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gedit/gedit-2.30.2.ebuild,v 1.1 2010/06/13 19:34:52 pacho Exp $

EAPI="2"
GCONF_DEBUG="no"
PYTHON_DEPEND="2"

inherit gnome2 python

DESCRIPTION="A text editor for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="doc +introspection spell"

# Note: introspection is *not* optional on pygobject: we need
# gi.repository.Gtk, etc.
RDEPEND=">=x11-libs/libSM-1.0
	>=dev-libs/libxml2-2.5.0
	>=dev-libs/glib-2.25.10
	>=x11-libs/gtk+-2.90:3[introspection?]
	>=x11-libs/gtksourceview-2.11.2:3.0[introspection?]
	>=dev-libs/libpeas-0.5.2[gtk]
	dev-python/pygobject[introspection]
	spell? (
		>=app-text/enchant-1.2
		>=app-text/iso-codes-0.35
	)"

DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9
	>=app-text/scrollkeeper-0.3.11
	>=app-text/gnome-doc-utils-0.3.2
	~app-text/docbook-xml-dtd-4.1.2
	doc? ( >=dev-util/gtk-doc-1 )"
# gnome-common and gtk-doc-am needed to eautoreconf

DOCS="AUTHORS BUGS ChangeLog MAINTAINERS NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-updater
		$(use_enable spell)"
}

src_install() {
	gnome2_src_install

	# Installed for plugins, but they're dlopen()-ed
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize /usr/$(get_libdir)/gedit-2/plugins
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/gedit-2/plugins
}
