# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $

EAPI="5"
GCONF_DEBUG="no"
GNOME_ORG_MODULE="vte"

inherit gnome3

DESCRIPTION="GNOME Setuid helper for opening ptys"
HOMEPAGE="http://git.gnome.org/browse/vte/"
# gnome-pty-helper is inside vte

LICENSE="LGPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
fi
IUSE="+hardened"

# gnome-pty-helper was spit out with 0.27.90
RDEPEND="!<x11-libs/vte-0.27.90"
DEPEND=""

src_prepare() {
	# As recommended by upstream (/usr/libexec/$PN is a setgid binary)
	if use hardened; then
		export SUID_CFLAGS="-fPIE ${SUID_CFLAGS}"
		export SUID_LDFLAGS="-pie ${SUID_LDFLAGS}"
	fi
	gnome3_src_prepare
}

src_configure() {
	ECONF_SOURCE="${S}/gnome-pty-helper" \
	gnome3_src_configure
}
