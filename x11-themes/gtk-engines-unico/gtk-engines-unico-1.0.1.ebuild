# Copyright 2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

if [[ ${PV} = 9999 ]]; then
	EBZR_REPO_URI="lp:unico"
	GCONF_DEBUG="no"
	inherit bzr gnome2-live # need gnome2-live for generating the build system
fi

MY_PN=${PN/gtk-engines-}
MY_PV=${PV/_p/+r}

DESCRIPTION="Unico Gtk+ 3 theme engine"
HOMEPAGE="https://launchpad.net/unico"
if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://launchpad.net/ubuntu/oneiric/+source/gtk3-engines-unico/${MY_PV}-0ubuntu1/+files/gtk3-engines-unico_${MY_PV}.orig.tar.gz"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi

LICENSE="LGPL-2.1"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND=">=dev-libs/glib-2.26.0:2
	>=x11-libs/cairo-1.10[glib]
	>=x11-libs/gtk+-3.1.10:3"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS NEWS" # ChangeLog, README are empty
}

src_unpack() {
	if [[ ${PV} = 9999 ]]; then
		bzr_src_unpack
	else
		default
	fi
}

src_prepare() {
	if [[ ${PV} = 9999 ]]; then
		gnome2-live_src_prepare
	else
		default
	fi
}

src_configure() {
	# currently, the only effect of --enable-debug is to add -g to CFLAGS
	econf \
		--disable-debug \
		--disable-maintainer-flags \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
}
