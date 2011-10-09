# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2:2.6"
EAPI="3"

# Need gnome2-utils for gnome2_icon_cache_update
inherit autotools eutils gnome2-utils python systemd

DESCRIPTION="Automatic bug detection and reporting tool"
HOMEPAGE="https://fedorahosted.org/abrt/"
SRC_URI="https://fedorahosted.org/released/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

COMMON_DEPEND="dev-libs/btparser
	>=dev-libs/glib-2.21:2
	dev-libs/libreport
	dev-libs/libxml2
	dev-libs/nss
	sys-apps/dbus
	sys-fs/inotify-tools
	x11-libs/gtk+:2
	x11-libs/libnotify"
RDEPEND="${COMMON_DEPEND}
	app-arch/cpio
	dev-libs/elfutils
	sys-devel/gdb"
DEPEND="${COMMON_DEPEND}
	app-text/asciidoc
	app-text/xmlto
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.9.0
	>=sys-devel/gettext-0.17"

pkg_setup() {
	python_set_active_version 2

	enewgroup abrt
	enewuser abrt -1 -1 -1 abrt
}

src_prepare() {
	# Disable redhat-specific code not usable in gentoo, or that requires
	# bugs.gentoo.org infra support.
	epatch "${FILESDIR}/${PN}-2.0.5-gentoo.patch"

	# Building against libreport-2.0.6 fails with -Werror due to redefinition
	# of kernel_tainted_short.
	# XXX: Check if needed on next libreport release.
	sed -e 's/-Werror\( \|$\)//g' \
		-i src/lib/Makefile.* src/daemon/Makefile.* src/applet/Makefile.* \
		   src/gui-gtk/Makefile.* src/plugins/Makefile.* src/cli/Makefile.* ||
		die "sed failed"

	mkdir m4
	eautoreconf

	ln -sfn $(type -P true) py-compile
	python_convert_shebangs -r 2 src
}

src_configure() {
	# Configure checks for python.pc; our python-2.7 installs python-2.7.pc,
	# while python-2.6 does not install any pkgconfig file.
	export PYTHON_CFLAGS=$(python-config --includes)
	export PYTHON_LIBS=$(python-config --libs)

	myeconfargs=( "--localstatedir=${EPREFIX}/var" )
	# --disable-debug enables debug!
	use debug && myeconfargs=( "${myeconfargs[@]}" --enable-debug )
	systemd_to_myeconfargs
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README

	keepdir /var/run/abrt
	# /var/spool/abrt is created by dev-libs/libreport

	diropts -m 700 -o abrt -g abrt
	keepdir /var/spool/abrt-upload

	diropts -m 775 -o abrt -g abrt
	keepdir /var/cache/abrt-di

	find "${D}" -name '*.la' -exec rm -f {} + || die

	newinitd "${FILESDIR}/${PN}-2.0.5-init" abrt
	newconfd "${FILESDIR}/${PN}-2.0.5-conf" abrt
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	python_mod_optimize abrt_exception_handler.py
	elog "To start the bug detection service on an openrc-based system, do"
	elog "# /etc/init.d/abrt start"
}

pkg_postrm() {
	gnome2_icon_cache_update
	python_mod_cleanup abrt_exception_handler.py
}
