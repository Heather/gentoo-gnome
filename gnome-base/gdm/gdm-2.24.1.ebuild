# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gdm/gdm-2.20.7.ebuild,v 1.5 2008/08/12 13:54:55 armin76 Exp $
EAPI=2

inherit eutils pam gnome2 gnome2-eapi-fixes

DESCRIPTION="GNOME Display Manager"
HOMEPAGE="http://www.gnome.org/projects/gdm/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE_LIBC="elibc_glibc"
IUSE="accessibility afs debug ipv6 gnome-keyring policykit selinux tcpd xinerama $IUSE_LIBC"

# Name of the tarball with gentoo specific files
GDM_EXTRA="${PN}-2.20.5-gentoo-files"

SRC_URI="${SRC_URI}
		 mirror://gentoo/${GDM_EXTRA}.tar.bz2"

# FIXME: automagic libxklavier check

RDEPEND=">=dev-libs/dbus-glib-0.74
		 >=dev-libs/glib-2.15.4
		 >=x11-libs/gtk+-2.10.0
		 >=x11-libs/pango-1.3
		 >=gnome-base/libglade-2
		 >=gnome-base/gconf-2.6.1
		 >=gnome-base/gnome-panel-2
		 >=x11-libs/libxklavier-3.5
		 x11-libs/libXft
		 app-text/iso-codes

		 x11-libs/gksu
		 x11-libs/libXi
		 x11-libs/libXau
		 x11-libs/libX11
		 x11-libs/libXext
		 x11-apps/sessreg
		 x11-libs/libXdmcp
		 virtual/pam
		 sys-auth/pambase[gnome-keyring?]
		 sys-auth/consolekit

		 accessibility? ( x11-libs/libXevie )
		 afs? ( net-fs/openafs sys-libs/lwp )
		 gnome-keyring? ( >=gnome-base/gnome-keyring-2.22[pam] )
		 policykit? ( >=sys-auth/policykit-0.8 )
		 selinux? ( sys-libs/libselinux )
		 tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
		 xinerama? ( x11-libs/libXinerama )

		 !gnome-extra/fast-user-switch-applet"
DEPEND="${RDEPEND}
		test? ( >=dev-libs/check-0.9.4 )
		sys-devel/gettext
		x11-proto/inputproto
		>=dev-util/intltool-0.40
		>=dev-util/pkgconfig-0.19
		>=app-text/scrollkeeper-0.1.4
		>=app-text/gnome-doc-utils-0.3.2"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-schemas-install
		--localstatedir=/var
		--with-xdmcp=yes
		--enable-authentication-scheme=pam
		--with-pam-prefix=/etc
		--with-console-kit=yes
		$(use_with accessibility xevie)
		$(use_enable debug)
		$(use_enable ipv6)
		$(use_enable policykit polkit)
		$(use_with selinux)
		$(use_with tcpd tcp-wrappers)
		$(use_with xinerama)"

	enewgroup gdm
	enewuser gdm -1 -1 /var/lib/gdm gdm
}

src_unpack() {
	gnome2_src_unpack

	# remove unneeded linker directive for selinux (#41022)
	epatch "${FILESDIR}/${PN}-2.13.0.1-selinux-remove-attr.patch"
	# Make it daemonize so that the boot process can continue (#236701)
	epatch "${FILESDIR}/${P}-fix-daemonize-regression.patch"
}

src_install() {
	gnome2_src_install

	local gentoodir="${WORKDIR}/${GDM_EXTRA}"

	# gdm-binary should be gdm to work with our init (#5598)
	rm -f "${D}/usr/sbin/gdm"
	dosym /usr/sbin/gdm-binary /usr/sbin/gdm

	# our x11's scripts point to /usr/bin/gdm
	dosym /usr/sbin/gdm-binary /usr/bin/gdm

	# log, etc.
	keepdir /var/log/gdm
	keepdir /var/gdm

	fowners root:gdm /var/gdm
	fperms 1770 /var/gdm

	# use our own session script
	rm -f "${D}/etc/X11/gdm/Xsession"
	exeinto /etc/X11/gdm
	doexe "${gentoodir}/Xsession"

	# add a custom xsession .desktop by default (#44537)
	exeinto /etc/X11/dm/Sessions
	doexe "${gentoodir}/custom.desktop"

	# avoid file collision, bug #213118
	rm -f "${D}/usr/share/xsessions/gnome.desktop"

	# We replace the pam stuff by our own
	rm -rf "${D}/etc/pam.d"

	use gnome-keyring && sed -i "s:#Keyring=::g" "${gentoodir}"/pam.d/*

	dopamd "${gentoodir}"/pam.d/*
	dopamsecurity console.apps "${gentoodir}/security/console.apps/gdmsetup"
}

pkg_postinst() {
	gnome2_pkg_postinst

	ewarn
	ewarn "This is an EXPERIMENTAL release, please bear with its bugs and"
	ewarn "visit us on #gentoo-desktop if you have problems."
	ewarn

	elog "To make GDM start at boot, edit /etc/conf.d/xdm"
	elog "and then execute 'rc-update add xdm default'."

	if use gnome-keyring; then
		elog "For autologin to unlock your keyring, you need to set an empty"
		elog "password on your keyring. Use app-crypt/seahorse for that."
	fi

	if [ -f "/etc/X11/gdm/gdm.conf" ]; then
		elog "You had /etc/X11/gdm/gdm.conf which is the old configuration"
		elog "file.  It has been moved to /etc/X11/gdm/gdm-pre-gnome-2.16"
		mv /etc/X11/gdm/gdm.conf /etc/X11/gdm/gdm-pre-gnome-2.16
	fi

	# Soft restart, assumes Gentoo defaults for file locations
	# Do restart after gdm.conf move above
	FIFOFILE=/var/gdm/.gdmfifo
	PIDFILE=/var/run/gdm.pid

	if [ -w ${FIFOFILE} ] ; then
		if [ -f ${PIDFILE} ] ; then
			if kill -0 `cat ${PIDFILE}`; then
				(echo;echo SOFT_RESTART) >> ${FIFOFILE}
			fi
		fi
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm

	if [[ "$(rc-config list default | grep xdm)" != "" ]] ; then
		elog "To remove GDM from startup please execute"
		elog "'rc-update del xdm default'"
	fi
}
