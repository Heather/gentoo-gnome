# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

VALA_MIN_VERSION=0.26

inherit fdo-mime gnome2-utils vala meson git-r3

EGIT_REPO_URI="https://github.com/elementary/calculator.git"
KEYWORDS="~x86 ~amd64"

DESCRIPTION="A tiny, simple calculator written in GTK+ and Vala"
HOMEPAGE="https://launchpad.net/pantheon-calculator"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/granite
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	$(vala_depend)"

src_prepare() {
	eapply_user
	meson_src_prepare
	vala_src_prepare
}

src_configure() {
	meson_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
}
