# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2:2.6"

inherit autotools eutils python

DESCRIPTION="Generic library for reporting various problems"
HOMEPAGE="https://fedorahosted.org/abrt/"
SRC_URI="https://fedorahosted.org/released/abrt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.21:2
	dev-libs/newt
	dev-libs/nss
	dev-libs/libtar
	dev-libs/libxml2
	dev-libs/xmlrpc-c
	gnome-base/gnome-keyring
	net-misc/curl[ssl]
	sys-apps/dbus
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/xmlto
	>=dev-util/intltool-0.3.50
	>=dev-util/pkgconfig-0.9.0
	>=sys-devel/gettext-0.17"

# Tests require python-meh, which is highly redhat-specific.
RESTRICT="tests"

pkg_setup() {
	python_set_active_version 2

	enewgroup abrt
	enewuser abrt -1 -1 -1 abrt
}

src_prepare() {
	# Replace redhat-specific defaults with gentoo ones
	epatch "${FILESDIR}/${PN}-2.0.6-gentoo.patch"

	# Disable bugzilla plugin for now (requires bugs.gentoo.org infra support)
	epatch "${FILESDIR}/${PN}-2.0.6-no-bugzilla.patch"

	# Needed for abrt-2.0.5, will be in next release
	epatch "${FILESDIR}/${P}-not-reportable.patch"

	# Wizard does not build with -Werror under gcc-4.6 (fails format-security
	# in gtk_message_dialog_new() calls)
	sed -e "s/ -Werror$//" -i src/gui-wizard-gtk/Makefile.* || die

	mkdir m4
	eautoreconf
	ln -sfn $(type -P true) py-compile
}

src_configure() {
	# Gentoo's xmlrpc-c does not provide a pkgconfig file
	# XXX: this is probably cross-compile-unfriendly
	export XMLRPC_CFLAGS=$(xmlrpc-c-config --cflags)
	export XMLRPC_LIBS=$(xmlrpc-c-config --libs)
	export XMLRPC_CLIENT_CFLAGS=$(xmlrpc-c-config client --cflags)
	export XMLRPC_CLIENT_LIBS=$(xmlrpc-c-config client --libs)
	# Configure checks for python.pc; our python-2.7 installs python-2.7.pc,
	# while python-2.6 does not install any pkgconfig file.
	export PYTHON_CFLAGS=$(python-config --includes)
	export PYTHON_LIBS=$(python-config --libs)

	ECONF="--localstatedir=${EPREFIX}/var"
	# --disable-debug enables debug!
	use debug && ECONF="${ECONF} --enable-debug"
	econf ${ECONF}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README

	# Need to set correct ownership for use by app-admin/abrt
	diropts -o abrt -g abrt
	keepdir /var/spool/abrt

	find "${D}" -name '*.la' -exec rm -f {} + || die
}

pkg_postinst() {
	python_mod_optimize report reportclient
}

pkg_postrm() {
	python_mod_cleanup report reportclient
}
