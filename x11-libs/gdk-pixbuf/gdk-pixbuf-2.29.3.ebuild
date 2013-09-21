# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit gnome.org libtool multilib-minimal

DESCRIPTION="Image loading library for GTK+"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+X debug +introspection jpeg jpeg2k tiff test"

COMMON_DEPEND="
	>=dev-libs/glib-2.34.0:2[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.4:0=[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.3[${MULTILIB_USEDEP}] )
	jpeg? ( virtual/jpeg:=[${MULTILIB_USEDEP}] )
	jpeg2k? ( media-libs/jasper:=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-3.9.2:0=[${MULTILIB_USEDEP}] )
	X? ( x11-libs/libX11[${MULTILIB_USEDEP}] )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-am-1.11
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"
# librsvg blocker is for the new pixbuf loader API, you lose icons otherwise
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gail-1000
	!<gnome-base/librsvg-2.31.0
	!<x11-libs/gtk+-2.21.3:2
	!<x11-libs/gtk+-2.90.4:3
"

src_prepare() {
	# This will avoid polluting the pkg-config file with versioned libpng,
	# which is causing problems with libpng14 -> libpng15 upgrade
	# See upstream bug #667068
	# First check that the pattern is present, to catch upstream changes on bumps,
	# because sed doesn't return failure code if it doesn't do any replacements
	grep -q  'l in libpng16' configure || die "libpng check order has changed upstream"
	sed -e 's:l in libpng16:l in libpng libpng16:' -i configure || die
	default
	elibtoolize # for Darwin modules, bug #????

	multilib_copy_sources
}

multilib_src_configure() {
	# png always on to display icons
	econf \
		$(usex debug --enable-debug=yes "") \
		$(use_with jpeg libjpeg) \
		$(use_with jpeg2k libjasper) \
		$(use_with tiff libtiff) \
		$(use_enable introspection) \
		$(use_with X x11) \
		--with-libpng
}

multilib_src_install() {
	default
	prune_libtool_files --modules

	if multilib_is_native_abi; then
		# Move files back.
		if path_exists -o "${ED}"/tmp/gdk-pixbuf-query-loaders.*; then
			mv "${ED}"/tmp/gdk-pixbuf-query-loaders.* "${ED}"/usr/bin || die
		fi
	else
		# Preserve ABI-variant of gdk-pixbuf-query-loaders,
		# then drop all the executables
		mkdir -p "${ED}"/tmp || die
		mv "${ED}"/usr/bin/gdk-pixbuf-query-loaders "${ED}"/tmp/gdk-pixbuf-query-loaders.${ABI} || die
		rm -r "${ED}"/usr/bin || die
	fi
}

pkg_postinst() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER

	multilib_foreach_abi gdk_pixbuf_query_loaders

	# FIXME: use subslots to get rebuilds when really needed
	# Every major version bump???
	if [ -e "${EROOT}"usr/lib/gtk-2.0/2.*/loaders ]; then
		elog "You need to rebuild ebuilds that installed into" "${EROOT}"usr/lib/gtk-2.0/2.*/loaders
		elog "to do that you can use qfile from portage-utils:"
		elog "emerge -va1 \$(qfile -qC ${EPREFIX}/usr/lib/gtk-2.0/2.*/loaders)"
	fi
}

gdk_pixbuf_query_loaders() {
	tmp_file=$(mktemp -t tmp_gdk_pixbuf_ebuild.XXXXXXXXXX)
	# be atomic!

	if multilib_is_native_abi; then
		gdk-pixbuf-query-loaders > "${tmp_file}"
	else
		gdk-pixbuf-query-loaders.${ABI} > "${tmp_file}"
	fi

	if [ "${?}" = "0" ]; then
		cat "${tmp_file}" > "${EROOT}usr/$(get_libdir)/gdk-pixbuf-2.0/2.10.0/loaders.cache"
	else
		ewarn "Cannot update loaders.cache, gdk-pixbuf-query-loaders failed to run"
	fi
	rm "${tmp_file}"
}
