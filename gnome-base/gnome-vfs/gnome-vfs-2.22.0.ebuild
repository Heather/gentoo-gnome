# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-vfs/gnome-vfs-2.20.1-r1.ebuild,v 1.1 2008/01/16 22:42:09 eva Exp $

WANT_AUTOMAKE=1.8
inherit eutils gnome2 autotools

DESCRIPTION="Gnome Virtual Filesystem"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="acl avahi doc gnutls hal ipv6 kerberos samba ssl"

RDEPEND=">=gnome-base/gconf-2
	>=dev-libs/glib-2.9.3
	>=dev-libs/libxml2-2.6
	>=net-misc/neon-0.25.3
	app-arch/bzip2
	virtual/fam
	gnome-base/gnome-mime-data
	>=x11-misc/shared-mime-info-0.14
	>=dev-libs/dbus-glib-0.71
	samba? ( >=net-fs/samba-3 )
	gnutls?	(
				net-libs/gnutls
				!gnome-extra/gnome-vfs-sftp
			)
	ssl?	(
		!gnutls?	(
				>=dev-libs/openssl-0.9.5
				!gnome-extra/gnome-vfs-sftp
				)
		)
	hal? ( >=sys-apps/hal-0.5.7 )
	avahi? ( >=net-dns/avahi-0.6 )
	kerberos? ( virtual/krb5 )
	acl? (
		sys-apps/acl
		sys-apps/attr
	)"
DEPEND="${RDEPEND}
	sys-devel/gettext
	gnome-base/gnome-common
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1 )"
PDEPEND="hal? ( >=gnome-base/gnome-mount-0.4 )"

DOCS="AUTHORS ChangeLog HACKING NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-schemas-install
		--disable-cdda
		--disable-howl
		--enable-http-neon
		$(use_enable ssl openssl)
		$(use_enable gnutls)
		$(use_enable samba)
		$(use_enable ipv6)
		$(use_enable hal)
		$(use_enable avahi)
		$(use_enable kerberos krb5)
		$(use_enable acl)"

	if use hal ; then
		G2CONF="${G2CONF}
			--with-hal-mount=/usr/bin/gnome-mount
			--with-hal-umount=/usr/bin/gnome-umount
			--with-hal-eject=/usr/bin/gnome-eject"
	fi

	# this works because of the order of conifgure parsing
	# so should always be behind the use_enable options
	# foser <foser@gentoo.org 19 Apr 2004
	use gnutls && use ssl && G2CONF="${G2CONF} --disable-openssl"
}

src_unpack() {
	gnome2_src_unpack

	# Allow the Trash on afs filesystems (#106118)
	epatch "${FILESDIR}"/${PN}-2.12.0-afs.patch

	# Fix compiling with headers missing
	epatch "${FILESDIR}"/${PN}-2.15.2-headers-define.patch

	# Fix for crashes running programs via sudo
	epatch "${FILESDIR}"/${PN}-2.16.0-no-dbus-crash.patch

	# Fix automagic dependencies
	epatch "${FILESDIR}"/${PN}-2.20.0-automagic-deps.patch
	epatch "${FILESDIR}"/${PN}-2.20.1-automagic-deps.patch

	# Fix to identify ${HOME} (#200897)
	# thanks to debian folks
	epatch "${FILESDIR}"/${PN}-2.20.0-home_dir_fakeroot.patch

	use doc || epatch "${FILESDIR}/${PN}-2.18.1-drop-gtk-doc-check.patch"

	eautoreconf
	intltoolize --force
}
