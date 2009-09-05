# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gvfs/gvfs-1.2.3.ebuild,v 1.4 2009/05/31 19:05:55 eva Exp $

EAPI="2"

inherit autotools bash-completion gnome2 eutils

DESCRIPTION="GNOME Virtual Filesystem Layer"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="archive avahi bluetooth cdda doc fuse gdu gnome gnome-keyring gphoto2 gudev hal samba udev"

# FIXME: gphoto2 && gudev => we need >libgphoto2-2.4.6 (unreleased)
# see configure.ac for details
RDEPEND=">=dev-libs/glib-2.21.2
	>=sys-apps/dbus-1.0
	>=net-libs/libsoup-2.25.1[gnome]
	dev-libs/libxml2
	net-misc/openssh
	archive? ( app-arch/libarchive )
	avahi? ( >=net-dns/avahi-0.6 )
	bluetooth? (
		dev-libs/dbus-glib
		net-wireless/bluez
		dev-libs/expat )
	fuse? ( sys-fs/fuse )
	gdu? ( >=sys-apps/gnome-disk-utility-0.4 )
	gnome? ( >=gnome-base/gconf-2.0 )
	gnome-keyring? ( >=gnome-base/gnome-keyring-1.0 )
	gphoto2? (
		>=media-libs/libgphoto2-2.4 )
	gudev? (
		cdda? ( >=dev-libs/libcdio-0.78.2[-minimal] )
		>=sys-fs/udev-145[extras] )
	hal? (
		cdda? ( >=dev-libs/libcdio-0.78.2[-minimal] )
		>=sys-apps/hal-0.5.10 )
	samba? ( >=net-fs/samba-3 )
	udev? ( >=sys-fs/udev-138 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.19
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	if use cdda && ! use hal && ! use gudev; then
		ewarn "You have \"+cdda\", but you have \"-hal\" and \"-gudev\""
		ewarn "cdda support will NOT be built unless you enable EITHER hal OR gudev"
	fi

	G2CONF="${G2CONF}
		--enable-http
		--disable-bash-completion
		$(use_enable archive)
		$(use_enable avahi)
		$(use_enable bluetooth obexftp)
		$(use_enable cdda)
		$(use_enable fuse)
		$(use_enable gdu)
		$(use_enable gnome gconf)
		$(use_enable gphoto2)
		$(use_enable hal)
		$(use_enable gnome-keyring keyring)
		$(use_enable samba)
		$(use_enable udev)"
}

src_prepare() {
	gnome2_src_prepare

	# Conditional patching purely to avoid eautoreconf
	use gphoto2 && epatch "${FILESDIR}/${PN}-1.2.2-gphoto2-stricter-checks.patch"

	if use archive; then
		epatch "${FILESDIR}/${PN}-1.2.2-expose-archive-backend.patch"
		echo "mount-archive.desktop.in" >> po/POTFILES.in
		echo "mount-archive.desktop.in.in" >> po/POTFILES.in
	fi

	use gphoto2 || use archive && eautoreconf
}

src_install() {
	gnome2_src_install
	use bash-completion && \
		dobashcompletion programs/gvfs-bash-completion.sh ${PN}
}

pkg_postinst() {
	gnome2_pkg_postinst
	use bash-completion && bash-completion_pkg_postinst

	# Reload messagebus config
	local dbus_initd="/etc/init.d/dbus"

	# Only do so if installing into current ROOT
	if test "${ROOT}" = "/" && test -x "${dbus_initd}"; then
		# Compatible with baselayout 1 & 2, bug 279936
		if ${dbus_initd} --quiet status; then
			${dbus_initd} reload
		fi
	fi
}
