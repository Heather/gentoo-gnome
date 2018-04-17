# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit meson bash-completion-r1 gnome2 systemd

DESCRIPTION="Virtual filesystem implementation for gio"
HOMEPAGE="https://wiki.gnome.org/Projects/gvfs"

LICENSE="LGPL-2+"
SLOT="0"

IUSE="afp avahi archive bluray cdda fuse google gnome-keyring gnome-online-accounts gphoto2 +http ios nfs policykit systemd test +udev udisks zeroconf samba +mtp"
REQUIRED_USE="
	cdda? ( udev )
	google? ( gnome-online-accounts )
	mtp? ( udev )
	udisks? ( udev )
	systemd? ( udisks )
"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x86-solaris"

RDEPEND="
	app-crypt/gcr:=
	>=dev-libs/glib-2.53.4:2
	sys-apps/dbus
	dev-libs/libxml2:2
	net-misc/openssh
	afp? ( >=dev-libs/libgcrypt-1.2.2:0= )
	avahi? ( net-dns/avahi )
	archive? ( app-arch/libarchive:= )
	bluray? ( media-libs/libbluray )
	fuse? ( >=sys-fs/fuse-2.8.0 )
	gnome-keyring? ( app-crypt/libsecret )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.7.1:= )
	google? (
		>=dev-libs/libgdata-0.17.3:=[crypt,gnome-online-accounts]
		>=net-libs/gnome-online-accounts-3.17.1:= )
	gphoto2? ( >=media-libs/libgphoto2-2.5.0:= )
	>=x11-libs/gtk+-3.0:3
	http? ( >=net-libs/libsoup-2.42:2.4 )
	ios? (
		>=app-pda/libimobiledevice-1.2:=
		>=app-pda/libplist-1:= )
	mtp? ( >=media-libs/libmtp-1.1.12 )
	nfs? ( >=net-fs/libnfs-1.9.7 )
	policykit? (
		sys-auth/polkit
		sys-libs/libcap )
	samba? ( >=net-fs/samba-4.5.10[client] )
	systemd? ( >=sys-apps/systemd-206:0= )
	udev? (
		cdda? ( dev-libs/libcdio-paranoia )
		virtual/libgudev:= )
	udisks? ( >=sys-fs/udisks-1.97:2 )
	zeroconf? ( >=net-dns/avahi-0.6 )
"

DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
	dev-util/gtk-doc-am
	test? (
		>=dev-python/twisted-core-12.3.0
		|| (
			net-analyzer/netcat
			net-analyzer/netcat6 ) )
	!udev? ( >=dev-libs/libgcrypt-1.2.2:0 )
"
# libgcrypt.m4, provided by libgcrypt, needed for eautoreconf, bug #399043
# test dependencies needed per https://bugzilla.gnome.org/700162

# Tests with multiple failures, this is being handled upstream at:
# https://bugzilla.gnome.org/700162
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-1.30.2-sysmacros.patch #580234
)

src_prepare() {
	if ! use udev; then
		sed -e 's/gvfsd-burn/ /' \
			-e 's/burn.mount.in/ /' \
			-e 's/burn.mount/ /' \
			-i daemon/Makefile.am || die

		# Uncomment when eautoreconf stops being needed always
		#eautoreconf
	fi

	gnome2_src_prepare
	eautoreconf
}

src_configure() {
	local emesonargs=(
		-Dgdu=false
		-Dgcr=true
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
		$(meson_use mtp)
		$(meson_use afp)
		$(meson_use archive)
		$(meson_use bluray)
		$(meson_use cdda)
		$(meson_use avahi dnssd)
		$(meson_use fuse)
		$(meson_use gnome-online-accounts goa)
		$(meson_use gnome-keyring keyring)
		$(meson_use google)
		$(meson_use gphoto2)
		$(meson_use http)
		$(meson_use ios afc)
		$(meson_use nfs)
		$(meson_use policykit admin)
		$(meson_use systemd logind)
		$(meson_use udev gudev)
		$(meson_use udisks udisks2)
		$(meson_use samba smb)
	)

	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}
