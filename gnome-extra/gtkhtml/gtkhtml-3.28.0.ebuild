# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gtkhtml/gtkhtml-3.26.3.ebuild,v 1.1 2009/07/19 09:25:49 eva Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Lightweight HTML Rendering/Printing/Editing Engine"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="3.14"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="glade"

# We keep bonobo until we can make sure no apps in tree uses
# the old composer code.
RDEPEND=">=x11-libs/gtk+-2.16
	>=gnome-base/gail-1.1
	>=x11-themes/gnome-icon-theme-2.22.0
	>=gnome-base/orbit-2
	app-text/enchant
	gnome-base/gconf:2
	>=app-text/iso-codes-0.49
	>=net-libs/libsoup-2.26.0
	glade? ( dev-util/glade:3 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40.0
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS BUGS ChangeLog NEWS README TODO"

pkg_setup() {
	ELTCONF="--reverse-deps"
	G2CONF="${G2CONF}
		--disable-static
		$(use_with glade glade-catalog)"
}

src_prepare() {
	gnome2_src_prepare

	# Fix deprecated API disabling in used glib library - this is not future-proof, bug 210657
	sed -i -e 's/DG_DISABLE_DEPRECATED//g' \
		"${S}/configure" "${S}/configure.ac" \
		|| die "sed 1 failed"

	sed -i -e 's:-DGTK_DISABLE_DEPRECATED=1 -DGDK_DISABLE_DEPRECATED=1 -DG_DISABLE_DEPRECATED=1 -DGNOME_DISABLE_DEPRECATED=1::g' \
		"${S}/a11y/Makefile.am" "${S}/a11y/Makefile.in" || die "sed 2 failed"
}
