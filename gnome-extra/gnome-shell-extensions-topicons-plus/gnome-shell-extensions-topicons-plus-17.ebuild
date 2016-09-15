# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit vcs-snapshot

DESCRIPTION="Shows legacy tray icons on top"
HOMEPAGE="https://extensions.gnome.org/extension/495/topicons/"
SRC_URI="https://github.com/phocean/TopIcons-plus/archive/v${PV}.tar.gz -> ${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.10
"
DEPEND="app-arch/xz-utils"

src_prepare() {
	default
}

src_install() {
	insinto "/usr/share/gnome-shell/extensions/${PN}"
	doins *
}

pkg_postinst() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
