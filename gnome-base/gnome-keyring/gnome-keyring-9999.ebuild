# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-keyring/gnome-keyring-2.32.1.ebuild,v 1.4 2011/01/02 21:32:23 mr_bones_ Exp $

EAPI="3"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2 multilib pam virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="debug doc pam test"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
fi

# USE=valgrind is probably not a good idea for the tree
#
# XXX: ARGH: libgcr is slotted, but libgck is not.
# Hence, gtk2/3 versions are not parallel installable.
RDEPEND=">=dev-libs/glib-2.25:2
	>=x11-libs/gtk+-2.90.0:3
	gnome-base/gconf
	>=sys-apps/dbus-1.0
	>=dev-libs/libgcrypt-1.2.2
	>=dev-libs/libtasn1-1
	sys-libs/libcap

	pam? ( virtual/pam )
"
#	valgrind? ( dev-util/valgrind )
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.9 )"
PDEPEND="gnome-base/libgnome-keyring"
# eautoreconf needs:
#	>=dev-util/gtk-doc-am-1.9

DOCS="AUTHORS ChangeLog NEWS README"

# tests fail in several ways, they should be fixed in the next cycle (bug #340283),
# revisit then.
# UPDATE: tests use system-installed libraries, fail with:
# ** WARNING **: couldn't load PKCS#11 module: /usr/lib64/pkcs11/gnome-keyring-pkcs11.so: Couldn't initialize module: The device was removed or unplugged 
RESTRICT="test"

pkg_setup() {
	# XXX: Automagic libcap support
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable test tests)
		$(use_enable pam)
		$(use_with pam pam-dir $(getpam_mod_dir))
		--with-root-certs=${ROOT}/etc/ssl/certs/
		--enable-ssh-agent
		--enable-gpg-agent
		--with-gtk=3.0"
#		$(use_enable valgrind)
}

src_prepare() {
	gnome2_src_prepare

	# Remove silly CFLAGS
	sed 's:CFLAGS="$CFLAGS -Werror:CFLAGS="$CFLAGS:' \
		-i configure.in configure || die "sed failed"

	# Remove DISABLE_DEPRECATED flags
	sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' \
		-i configure.in configure || die "sed 2 failed"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "emake check failed!"
}
