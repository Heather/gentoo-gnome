# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

inherit linux-info gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Simple GNOME 3 application to access remote or virtual systems"
HOMEPAGE="https://live.gnome.org/Design/Apps/Boxes"

LICENSE="LGPL-2"
SLOT="0"
IUSE="bindist smartcard usbredir"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64" # qemu-kvm[spice] is 64bit-only
fi

# NOTE: sys-fs/* stuff is called via exec()
RDEPEND="
	>=dev-libs/libxml2-2.7.8:2
	>=virtual/udev-165[gudev]
	>=dev-libs/glib-2.29.90:2
	>=dev-libs/gobject-introspection-0.9.6
	>=sys-libs/libosinfo-0.2.1
	>=app-emulation/qemu-1.3.1[spice,smartcard?,usbredir?]
	>=app-emulation/libvirt-0.9.3[libvirtd,qemu]
	>=app-emulation/libvirt-glib-0.1.2
	>=x11-libs/gtk+-3.5.5:3
	>=net-libs/gtk-vnc-0.4.4[gtk3]
	>=net-misc/spice-gtk-0.16[gtk3,smartcard?,usbredir?]

	>=app-misc/tracker-0.14:0=[iso]

	>=media-libs/clutter-gtk-1.3.2:1.0
	>=media-libs/clutter-1.11.14:1.0
	>=sys-apps/util-linux-2.20
	>=net-libs/libsoup-2.38:2.4

	sys-fs/fuse
	sys-fs/fuseiso
	sys-fs/mtools
	!bindist? ( gnome-extra/gnome-boxes-nonfree )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		>=dev-lang/vala-0.17.2:0.18[vapigen]
		sys-libs/libosinfo[introspection,vala]
		app-emulation/libvirt-glib[introspection,vala]
		net-libs/gtk-vnc[introspection,vala]
		net-misc/spice-gtk[introspection,vala]"
fi

pkg_pretend() {
	linux_config_exists

	if ! { linux_chkconfig_present KVM_AMD || \
		linux_chkconfig_present KVM_INTEL; }; then
		ewarn "You need KVM support in your kernel to use GNOME Boxes!"
	fi
}

src_prepare() {
	# Do not change CFLAGS, wondering about VALA ones but appears to be
	# needed as noted in configure comments below
	sed 's/CFLAGS="$CFLAGS -O0 -ggdb3"' -i configure.ac || die
	gnome2_src_configure
}

src_configure() {
	DOCS="AUTHORS README NEWS THANKS TODO"
	# debug needed for splitdebug proper behavior (cardoe)
	gnome2_src_configure \
		--enable-debug \
		--disable-strict-cc \
		$(use_enable usbredir) \
		$(use_enable smartcard) \
		VALAC=$(type -P valac-0.18) \
		VAPIGEN=$(type -P vapigen-0.18)
}

pkg_postinst() {
	gnome2_pkg_postinst
	elog "Before running gnome-boxes, you will need to load the KVM modules"
	elog "If you have an Intel Processor, run:"
	elog "	modprobe kvm-intel"
	einfo
	elog "If you have an AMD Processor, run:"
	elog "	modprobe kvm-amd"
}
