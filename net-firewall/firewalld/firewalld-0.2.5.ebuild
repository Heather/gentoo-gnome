# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

GCONF_DEBUG="no"
PYTHON_DEPEND="2"
PYTHON_USE_WITH="xml"

inherit autotools eutils gnome2 python systemd

DESCRIPTION="Dynamic firewall service with a D-BUS interface"
HOMEPAGE="http://fedoraproject.org/wiki/FirewallD
	https://fedorahosted.org/firewalld/"
SRC_URI="https://fedorahosted.org/released/${PN}/${P}.tar.bz2
	http://dev.gentoo.org/~tetromino/distfiles/${PN}/${P}-icons.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

COMMON_DEPEND="dev-libs/glib:2
"
RDEPEND="${COMMON_DEPEND}
	dev-python/dbus-python
	dev-python/python-slip[dbus]
	net-firewall/ebtables
	>=net-firewall/iptables-1.4.6[ipv6]
	sys-auth/polkit
	gtk? (
		dev-python/pygobject:3
		net-misc/networkmanager[introspection]
		x11-libs/gtk+:3[introspection]
		x11-libs/libnotify[introspection] )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	sys-devel/gettext
"

# Tests will modify the system firewall
RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable gtk applet)
		$(systemd_with_unitdir systemd-unitdir)"

	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_clean_py-compile_files
	python_convert_shebangs -r 2 .

	epatch "${FILESDIR}/${PN}-0.2.5-gentoo-paths.patch"

	# icons missing in tarball :/
	cp -vr "${WORKDIR}/${P}-icons/"{16x16,22x22,24x24,32x32,48x48,scalable} \
		src/icons/ || die "cp failed"

	# pre-generated configure missing from tarball :/
	if [[ ! -f po/POTFILES.in ]]; then
		for i in $(cat po/POTFILES.in.in); do echo $i>>po/POTFILES.in; done
	fi
	eautoreconf
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	diropts 0750
	keepdir /etc/firewalld/{icmptypes,services,zones}
	newinitd "${FILESDIR}/${PN}-0.2.5.init" ${PN}
	newconfd "${FILESDIR}/${PN}-0.2.5.conf" ${PN}
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize firewall
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup firewall
}
