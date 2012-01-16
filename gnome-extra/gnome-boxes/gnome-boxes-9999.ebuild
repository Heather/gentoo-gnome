# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"

inherit linux-info gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Simple GNOME 3 application to access remote or virtual systems"
HOMEPAGE="https://live.gnome.org/Design/Apps/Boxes"

LICENSE="LGPL-2"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

# CHECK: We're hard-depending on qemu-kvm[spice]. Does app-emulation/qemu
# support spice or not?
# NOTE: sys-fs/* stuff is called via exec()
RDEPEND="
	>=dev-libs/libxml2-2.7.8:2
	>=sys-fs/udev-147[gudev]
	>=dev-libs/glib-2.29.90:2
	>=dev-libs/gobject-introspection-0.9.6
	>=sys-libs/libosinfo-0.0.5
	app-emulation/qemu-kvm[spice]
	>=app-emulation/libvirt-0.9.3[libvirtd,qemu]
	>=app-emulation/libvirt-glib-0.0.4
	>=x11-libs/gtk+-3.3.5:3
	>=net-libs/gtk-vnc-0.4.4[gtk3]
	>=net-misc/spice-gtk-0.7.98[gtk3]

	sys-fs/fuse
	sys-fs/fuseiso
	sys-fs/mtools"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17"

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		>=dev-lang/vala-0.14.0:0.14
		>=sys-libs/libosinfo-0.0.5[introspection,vala]
		>=app-emulation/libvirt-glib-0.0.4[introspection,vala]
		>=net-libs/gtk-vnc-0.4.4[gtk3,introspection,vala]
		>=net-misc/spice-gtk-0.7.1[introspection,vala]"
fi

pkg_pretend() {
	linux_config_exists

	if ! { linux_chkconfig_present KVM_AMD || \
		linux_chkconfig_present KVM_INTEL; }; then
		ewarn "You need KVM support in your kernel to use GNOME Boxes!"
	fi
}

pkg_setup() {
	DOCS="AUTHORS README NEWS THANKS TODO"
	G2CONF="--disable-schemas-compile
		--disable-strict-cc
		VALAC=$(type -P valac-0.14)"
}

pkg_postinst() {
	elog "Before running gnome-boxes, you will need to load the KVM modules"
	elog "If you have an Intel Processor, run:"
	elog "	modprobe kvm-intel"
	einfo
	elog "If you have an AMD Processor, run:"
	elog "	modprobe kvm-amd"
}
