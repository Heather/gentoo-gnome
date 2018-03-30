# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

VALA_MIN_API_VERSION=0.22

inherit gnome2-utils vala meson git-r3

DESCRIPTION="The terminal of the 21st century"
HOMEPAGE="https://launchpad.net/pantheon-terminal"
EGIT_REPO_URI="https://github.com/elementary/terminal.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	>=dev-libs/granite-0.3
	x11-libs/libnotify
	x11-libs/gtk+:3
	x11-libs/vte:2.91[vala]"
DEPEND="${RDEPEND}
	$(vala_depend)
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

src_prepare() {
	eapply "${FILESDIR}"/no-appstream.patch
	default
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
