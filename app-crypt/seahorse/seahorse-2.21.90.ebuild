# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/seahorse/seahorse-2.20.1.ebuild,v 1.6 2007/11/26 14:21:33 corsair Exp $

EAPI="1"

inherit gnome2 eutils flag-o-matic

GNOME_TARBALL_SUFFIX="gz"

DESCRIPTION="A GNOME application for managing encryption keys"
HOMEPAGE="http://www.gnome.org/projects/seahorse/index.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE="applet avahi dbus debug epiphany gedit keyring ldap libnotify nautilus"

RDEPEND=">=gnome-base/libgnome-2.14
		 >=gnome-base/libgnomeui-2.10
		 >=gnome-base/gnome-vfs-2.0
		 >=gnome-base/libglade-2.0
		 >=gnome-base/gconf-2.0
		 >=dev-libs/glib-2.10
		 >=x11-libs/gtk+-2.10
		 net-libs/libsoup:2.2
		 >=dev-libs/libxml2-2.6.0
		 >=app-crypt/gpgme-1.0.0
		 || (
				=app-crypt/gnupg-1.2*
				=app-crypt/gnupg-1.4*
				=app-crypt/gnupg-2.0*
			)
		   net-misc/openssh
		   x11-misc/shared-mime-info
		 avahi? ( >=net-dns/avahi-0.6 )
		 dbus?	( ||	(
							>=dev-libs/dbus-glib-0.72
							( <sys-apps/dbus-0.90 >=sys-apps/dbus-0.60 )
						)
					applet? ( >=gnome-base/gnome-panel-2.10 )
					epiphany? ( >=www-client/epiphany-2.14 )
					gedit? ( >=app-editors/gedit-2.16 )
				)
		 keyring? ( >=gnome-base/gnome-keyring-2.21.3.2 )
		 ldap? ( net-nds/openldap )
		 libnotify? ( >=x11-libs/libnotify-0.3.2 )
		 nautilus? ( >=gnome-base/nautilus-2.10 )"
DEPEND="${RDEPEND}
		sys-devel/gettext
		>=app-text/gnome-doc-utils-0.3.2
		>=app-text/scrollkeeper-0.3
		>=dev-util/pkgconfig-0.20
		>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README TODO THANKS"

pkg_setup() {
	if ! use dbus ; then
		if use applet ; then
			elog
			elog "The panel applet requires that you build seahorse with DBUS support."
			elog
		fi

		if use gedit ; then
			elog
			elog "The GEdit plugin requires that you build seahorse with DBUS support."
			elog
		fi

		if use epiphany ; then
			elog
			elog "The epiphany plugin requires that you build seahorse with DBUS support."
			elog
		fi

		eerror "Please add dbus to your USE flags and re-emerge seahorse"
		eerror "plugins require dbus support"
	fi

	G2CONF="${G2CONF} --enable-ssh --disable-update-mime-database \
			--enable-hkp --with-keyserver --enable-agent \
			--localstatedir=${D}/var/lib/scrollkeeper/ \
			$(use_enable applet) \
			$(use_enable avahi sharing) \
			$(use_enable dbus) \
			$(use_enable debug) \
			$(use_enable epiphany) \
			$(use_enable gedit) \
			$(use_enable keyring gnome-keyring) \
			$(use_enable ldap) \
			$(use_enable libnotify) \
			$(use_enable nautilus)"
}

src_unpack() {
	gnome2_src_unpack
	epatch "${FILESDIR}/${PN}-0.9.10-update-mime.patch"
}

src_compile() {
	append-ldflags $(bindnow-flags)
	gnome2_src_compile
}

src_install() {
	gnome2_src_install

	# remove conflicts with x11-misc/shared-mime-info
	rm -rf "${D}/usr/share/mime/"{application,magic,globs,XMLnamespaces}

	chmod -s "${D}/usr/bin/seahorse-agent"
	chmod -s "${D}/usr/bin/seahorse-daemon"

	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/70-seahorse-agent"
}
