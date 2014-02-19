# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
VALA_MIN_API_VERSION="0.18"
VALA_USE_DEPEND="vapigen"

inherit git-r3 bash-completion-r1 systemd user toolchain-funcs vala virtualx udev eutils


DESCRIPTION="A network configuration daemon"
HOMEPAGE="http://www.gnome.org/projects/NetworkManager/"
EGIT_REPO_URI="git://anongit.freedesktop.org/NetworkManager/NetworkManager"

LICENSE="GPL-2"
SLOT="0"

IUSE="avahi bluetooth connection-sharing consolekit dhclient dhcpcd gnutls +introspection modemmanager +nss +ppp resolvconf systemd test vala +wext"

KEYWORDS=""
REQUIRED_USE="
modemmanager? ( ppp )
^^ ( nss gnutls )
^^ ( dhclient dhcpcd )
?? ( consolekit systemd )
"
COMMON_DEPEND="
>=sys-apps/dbus-1.2
>=dev-libs/dbus-glib-0.94
>=dev-libs/glib-2.30
>=dev-libs/libnl-3.2.7:3=
dev-libs/libndp
>=sys-auth/polkit-0.106
>=net-libs/libsoup-2.26:2.4=
>=net-wireless/wpa_supplicant-0.7.3-r3[dbus]
>=virtual/udev-165[gudev]
bluetooth? ( >=net-wireless/bluez-4.82 )
avahi? ( net-dns/avahi:=[autoipd] )
connection-sharing? (
net-dns/dnsmasq
net-firewall/iptables )
gnutls? (
dev-libs/libgcrypt:=
net-libs/gnutls:= )
modemmanager? ( >=net-misc/modemmanager-0.7.991 )
nss? ( >=dev-libs/nss-3.11:= )
dhclient? ( =net-misc/dhcp-4*[client] )
dhcpcd? ( >=net-misc/dhcpcd-4.0.0_rc3 )
introspection? ( >=dev-libs/gobject-introspection-0.10.3 )
ppp? ( >=net-dialup/ppp-2.4.5[ipv6] )
resolvconf? ( net-dns/openresolv )
systemd? ( >=sys-apps/systemd-200 )
!systemd? ( sys-power/upower )
"
RDEPEND="${COMMON_DEPEND}
consolekit? ( sys-auth/consolekit )
"
DEPEND="${COMMON_DEPEND}
dev-util/gtk-doc
dev-util/gtk-doc-am
>=dev-util/intltool-0.40
>=sys-devel/gettext-0.17
>=sys-kernel/linux-headers-2.6.29
virtual/pkgconfig
vala? ( $(vala_depend) )
test? (
dev-lang/python:2.7
dev-python/dbus-python[python_targets_python2_7]
dev-python/pygobject:2[python_targets_python2_7] )
"

src_prepare() {
NOCONFIGURE=yes ./autogen.sh

use vala && vala_src_prepare
}

src_configure() {
econf \
--disable-more-warnings \
--localstatedir=/var \
--with-dbus-sys-dir=/etc/dbus-1/system.d \
--with-udev-dir="$(udev_get_udevdir)" \
--with-iptables=/sbin/iptables \
--enable-concheck \
--with-crypto=$(usex nss nss gnutls) \
--with-session-tracking=$(usex consolekit consolekit $(usex systemd systemd no)) \
--with-suspend-resume=$(usex systemd systemd upower) \
--disable-wimax \
$(use_enable introspection) \
$(use_enable ppp) \
$(use_with dhclient) \
$(use_with dhcpcd) \
$(use_with modemmanager modem-manager-1) \
$(use_with resolvconf) \
$(use_enable test tests) \
$(use_enable vala) \
$(use_with wext) \
"$(systemd_with_unitdir)"
}

src_install() {
default

# Gentoo init script
newinitd "${FILESDIR}/init.d.NetworkManager" NetworkManager

# /var/run/NetworkManager is used by some distros, but not by Gentoo
rmdir -v "${ED}/var/run/NetworkManager" || die "rmdir failed"
rm -rf "${ED}/usr/share/bash-completion/nmcli" || die "rm failed"
# Need to keep the /etc/NetworkManager/dispatched.d for dispatcher scripts
keepdir /etc/NetworkManager/dispatcher.d

if use systemd; then
# Our init.d script requires running a dispatcher script that annoys
# systemd users; bug #434692
rm -rv "${ED}/etc/init.d" || die "rm failed"
else
# Provide openrc net dependency only when nm is connected
exeinto /etc/NetworkManager/dispatcher.d
newexe "${FILESDIR}/10-openrc-status-r4" 10-openrc-status
sed -e "s:@EPREFIX@:${EPREFIX}:g" \
-i "${ED}/etc/NetworkManager/dispatcher.d/10-openrc-status" || die

# Default conf.d file
newconfd "${FILESDIR}/conf.d.NetworkManager" NetworkManager
fi

# Add keyfile plugin support
keepdir /etc/NetworkManager/system-connections
chmod 0600 "${ED}"/etc/NetworkManager/system-connections/.keep* # bug #383765
insinto /etc/NetworkManager

# Allow users in plugdev group to modify system connections
insinto /usr/share/polkit-1/rules.d/
doins "${FILESDIR}/01-org.freedesktop.NetworkManager.settings.modify.system.rules"

# Remove useless .la files
prune_libtool_files --modules
}
