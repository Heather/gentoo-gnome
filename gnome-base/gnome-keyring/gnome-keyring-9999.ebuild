# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-keyring/gnome-keyring-2.32.1.ebuild,v 1.4 2011/01/02 21:32:23 mr_bones_ Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 multilib pam virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="+caps debug doc pam test"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
fi

# USE=valgrind is probably not a good idea for the tree
RDEPEND=">=dev-libs/glib-2.25:2
	>=x11-libs/gtk+-2.90.0:3
	app-misc/ca-certificates
	>=dev-libs/libgcrypt-1.2.2
	>=dev-libs/libtasn1-1
	>=dev-libs/p11-kit-0.6
	>=sys-apps/dbus-1.0
	caps? ( sys-libs/libcap-ng )
	pam? ( virtual/pam )
"
#	valgrind? ( dev-util/valgrind )
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.9 )"
PDEPEND="gnome-base/libgnome-keyring"
# eautoreconf needs:
#	>=dev-util/gtk-doc-am-1.9

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable test tests)
		$(use_with caps libcap-ng)
		$(use_enable pam)
		$(use_with pam pam-dir $(getpam_mod_dir))
		--with-root-certs=${EPREFIX}/etc/ssl/certs/
		--enable-ssh-agent
		--enable-gpg-agent
		--disable-update-mime"
#		$(use_enable valgrind)
}

src_prepare() {
	# Disable gcr tests due to weirdness with opensc
	# ** WARNING **: couldn't load PKCS#11 module: /usr/lib64/pkcs11/gnome-keyring-pkcs11.so: Couldn't initialize module: The device was removed or unplugged
	sed -e 's/^\(SUBDIRS = \.\)\(.*\)/\1/' \
		-i gcr/Makefile.* || die "sed failed"

	gnome2_src_prepare
}

src_test() {
	# FIXME: /gkm/transaction/ tests fail
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "emake check failed!"
}
