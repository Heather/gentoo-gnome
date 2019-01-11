# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic gnome2 meson multilib-minimal multilib

DESCRIPTION="Image loading library for GTK+"
HOMEPAGE="https://git.gnome.org/browse/gdk-pixbuf"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="X debug +introspection jpeg jpeg2k tiff test"

RESTRICT="mirror"

COMMON_DEPEND="
	>=dev-libs/glib-2.48.0:2[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.4:0=[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.3:= )
	jpeg? ( virtual/jpeg:0=[${MULTILIB_USEDEP}] )
	jpeg2k? ( media-libs/jasper:=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-3.9.2:0=[${MULTILIB_USEDEP}] )
	X? ( x11-libs/libX11[${MULTILIB_USEDEP}] )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.19
	virtual/pkgconfig
"
# librsvg blocker is for the new pixbuf loader API, you lose icons otherwise
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gail-1000
	!<gnome-base/librsvg-2.31.0
	!<x11-libs/gtk+-2.21.3:2
	!<x11-libs/gtk+-2.90.4:3
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gdk-pixbuf-query-loaders$(get_exeext)
)

PATCHES=(
	# See https://bugzilla.gnome.org/show_bug.cgi?id=756590
	"${FILESDIR}"/${PN}-2.32.3-fix-lowmem-uclibc.patch
)

meson_use_multilib_native_enable() {
	multilib_native_usex "$1" "-D${2-$1}=true" "-D${2-$1}=false"
}

multilib_src_configure() {
	local emesonargs=(
		-Dinstalled_tests=false
		$(meson_use_multilib_native_enable introspection gir)
		$(meson_use jpeg)
		$(meson_use jpeg2k jasper)
		$(meson_use tiff)
		$(meson_use X x11)
	)

	meson_src_configure
}

multilib_src_compile() { meson_src_compile; }

multilib_src_install() {
	# Parallel install fails when no gdk-pixbuf is already installed, bug #481372
	MAKEOPTS="${MAKEOPTS} -j1" meson_src_install
}

# FIXME: use MULTILIB_WRAPPED_HEADERS
# Header checksum mismatch, that's very wrong thing to do is to ignore that check...
multilib-minimal_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	multilib-minimal_abi_src_install() {
		debug-print-function ${FUNCNAME} "$@"

		pushd "${BUILD_DIR}" >/dev/null || die
		if declare -f multilib_src_install >/dev/null ; then
			multilib_src_install
		else
			# default_src_install will not work here as it will
			# break handling of DOCS wrt #468092
			# so we split up the emake and doc-install part
			# this is synced with __eapi4_src_install
			if [[ -f Makefile || -f GNUmakefile || -f makefile ]] ; then
				emake DESTDIR="${D}" install
			fi
		fi

		multilib_prepare_wrappers
		# do not check headers, they are different :(
		#multilib_check_headers
		popd >/dev/null || die
	}
	multilib_foreach_abi multilib-minimal_abi_src_install
	multilib_install_wrappers

	if declare -f multilib_src_install_all >/dev/null ; then
		multilib_src_install_all
	else
		einstalldocs
	fi
}

pkg_preinst() {
	gnome2_pkg_preinst

	multilib_pkg_preinst() {
		# Make sure loaders.cache belongs to gdk-pixbuf alone
		local cache="usr/$(get_libdir)/${PN}-2.0/2.10.0/loaders.cache"

		if [[ -e ${EROOT}${cache} ]]; then
			cp "${EROOT}"${cache} "${ED}"/${cache} || die
		else
			touch "${ED}"/${cache} || die
		fi
	}

	multilib_foreach_abi multilib_pkg_preinst
}

pkg_postinst() {
	gdk-pixbuf-query-loaders > /usr/lib64/gdk-pixbuf-2.0/2.10.0/loaders.cache
}
