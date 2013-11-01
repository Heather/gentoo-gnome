# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluez/bluez-4.101-r7.ebuild,v 1.2 2013/10/06 08:29:26 pacho Exp $

EAPI=5
inherit autotools eutils multilib systemd user udev

DESCRIPTION="Bluetooth Tools and System Daemons for Linux"
HOMEPAGE="http://www.bluez.org/"
SRC_URI="mirror://kernel/linux/bluetooth/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client +cups debug +obex +systemd"

CDEPEND="
	>=dev-libs/glib-2.28:2
	>=sys-apps/dbus-1.6:=
	>=sys-apps/hwids-20121202.2
	>=virtual/udev-171
	cups? ( net-print/cups:= )
	sys-libs/readline:=
"
DEPEND="${CDEPEND}
	sys-devel/flex
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}"

DOCS=( AUTHORS ChangeLog README TODO )

src_prepare() {
	default
	# https://github.com/Heather/gentoo-gnome/issues/38
	# https://bugs.launchpad.net/ubuntu/+source/bluez/+bug/269851
	epatch "${FILESDIR}"/bluez-5.10-work-around-Logitech-diNovo-Edge-keyboard-firmware-issue.patch

	# Gentoo installs CUPS backends to /usr/libexec
	sed -i Makefile.in \
		-e 's:cupsdir = \$(libdir):cupsdir = ${exec_prefix}/libexec:'
}

src_configure() {
	econf \
		--localstatedir=/var \
		--enable-library \
		$(use_enable client) \
		$(use_enable cups) \
		$(use_enable debug) \
		$(use_enable obex) \
		$(use_enable systemd) \
		--with-udevdir="$(get_udevdir)" \
		--with-systemdsystemunitdir="$(systemd_get_unitdir)" \
		--with-systemduserunitdir="$(systemd_get_userunitdir)"
}

src_install() {
	default

	insinto /etc/bluetooth
	find profiles -type f -name \*.conf | xargs doins src/main.conf

	elog "If you need support for bluetooth audio devices, you will"
	elog "need to emerge >=media-sound/pulseaudio-4.99_pre20131028."
}

pkg_postinst() {
	udev_reload
}
