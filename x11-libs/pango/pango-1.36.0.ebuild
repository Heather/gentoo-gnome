# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 toolchain-funcs multilib-minimal

DESCRIPTION="Internationalized text layout and rendering library"
HOMEPAGE="http://www.pango.org/"

LICENSE="LGPL-2+ FTL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

IUSE="X +introspection"

# Bump cairo dep to be safer:
# https://bugzilla.gnome.org/show_bug.cgi?id=700247#c4
RDEPEND="
	>=media-libs/harfbuzz-0.9.9:=[glib(+),truetype(+),${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.33.12:2[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.10.91:1.0=[${MULTILIB_USEDEP}]
	media-libs/freetype:2=[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.10:=[X?,${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libXrender[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		>=x11-libs/libXft-2.0.0[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.13
	virtual/pkgconfig
	X? ( x11-proto/xproto[${MULTILIB_USEDEP}] )
	!<=sys-devel/autoconf-2.63:2.5
"

src_prepare() {
	tc-export CXX

	epatch "${FILESDIR}/${PN}-1.32.1-lib64.patch"
	eautoreconf

	gnome2_src_prepare

	multilib_copy_sources
}

multilib_src_configure() {
	gnome2_src_configure \
		$(use_enable introspection) \
		$(use_with X xft) \
		"$(usex X --x-includes="${EPREFIX}/usr/include" "")" \
		"$(usex X --x-libraries="${EPREFIX}/usr/$(get_libdir)" "")"
}

multilib_src_install() {
	gnome2_src_install

	local PANGO_CONFDIR="/etc/pango/${CHOST}"
	dodir "${PANGO_CONFDIR}"
	keepdir "${PANGO_CONFDIR}"

	if multilib_is_native_abi; then
		# Move files back.
		if path_exists -o "${ED}"/tmp/pango-querymodules.*; then
			mv "${ED}"/tmp/pango-querymodules.* "${ED}"/usr/bin || die
		fi
	else
		# Preserve ABI-variant of pango-querymodules,
		# then drop all the executables
		mkdir -p "${ED}"/tmp || die
		mv "${ED}"/usr/bin/pango-querymodules "${ED}"/tmp/pango-querymodules.${ABI} || die
		rm -r "${ED}"/usr/bin || die
	fi

}

pkg_postinst() {
	gnome2_pkg_postinst

	multilib_foreach_abi pango_querymodules

	if [[ ${REPLACING_VERSIONS} < 1.30.1 ]]; then
		elog "In >=${PN}-1.30.1, default configuration file locations moved from"
		elog "~/.pangorc and ~/.pangox_aliases to ~/.config/pango/pangorc and"
		elog "~/.config/pango/pangox.aliases"
	fi
}

pango_querymodules() {
	einfo "Generating modules listing..."
	local PANGO_CONFDIR="${EROOT}/etc/pango/${CHOST}"
	local pango_conf="${PANGO_CONFDIR}/pango.modules"
	local tmp_file=$(mktemp -t tmp_pango_ebuild.XXXXXXXXXX)
	if multilib_is_native_abi; then
		querybin="pango-querymodules"
	else
		querybin="pango-querymodules.${ABI}"
	fi

	# be atomic!
	if ${querybin} --system \
		"${EROOT}"usr/$(get_libdir)/pango/1.8.0/modules/*$(get_modname) \
			> "${tmp_file}"; then
		cat "${tmp_file}" > "${pango_conf}" || {
			rm "${tmp_file}"; die; }
	else
		ewarn "Cannot update pango.modules, file generation failed"
	fi
	rm "${tmp_file}"
}
