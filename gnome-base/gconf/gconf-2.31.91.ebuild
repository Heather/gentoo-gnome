# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gconf/gconf-2.28.1.ebuild,v 1.5 2010/06/04 19:51:46 maekke Exp $

EAPI="2"

inherit eutils gnome2

MY_PN=GConf
MY_P=${MY_PN}-${PV}
PVP=(${PV//[-\._]/ })

DESCRIPTION="Gnome Configuration System and Daemon"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="mirror://gnome/sources/${MY_PN}/${PVP[0]}.${PVP[1]}/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc +introspection ldap policykit"

RDEPEND=">=dev-libs/glib-2.25.9
	>=x11-libs/gtk+-2.14:2
	>=dev-libs/dbus-glib-0.74
	>=sys-apps/dbus-1
	>=gnome-base/orbit-2.4
	>=dev-libs/libxml2-2
	ldap? ( net-nds/openldap )
	policykit? ( sys-auth/polkit )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	>=dev-util/gtk-doc-am-1.10
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-gtk
		--disable-static
		--enable-gsettings-backend
		$(use_with ldap openldap)
		$(use_enable introspection)
		$(use_enable policykit defaults-service)"
	kill_gconf

	# Need host's IDL compiler for cross or native build, bug #262747
	export EXTRA_EMAKE="${EXTRA_EMAKE} ORBIT_IDL=/usr/bin/orbit-idl-2"
}

src_prepare() {
	# Do not start gconfd when installing schemas, fix bug #238276, upstream ?
	epatch "${FILESDIR}/${PN}-2.24.0-no-gconfd.patch"

	# Do not crash in gconf_entry_set_value() when entry pointer is NULL
	epatch "${FILESDIR}/${PN}-2.28.0-entry-set-value-sigsegv.patch"

	gnome2_src_prepare
}

# Can't run tests, missing script.
#src_test() {
#	emake -C tests || die "make tests failed"
#	sh "${S}"/tests/runtests.sh || die "running tests failed"
#}

src_install() {
	gnome2_src_install

	keepdir /etc/gconf/gconf.xml.mandatory
	keepdir /etc/gconf/gconf.xml.defaults
	# Make sure this directory exists, bug #268070, upstream #572027
	keepdir /etc/gconf/gconf.xml.system

	echo 'CONFIG_PROTECT_MASK="/etc/gconf"' > 50gconf
	doenvd 50gconf || die "doenv failed"
	dodir /root/.gconfd
}

pkg_preinst() {
	kill_gconf
}

pkg_postinst() {
	kill_gconf

	# change the permissions to avoid some gconf bugs
	einfo "changing permissions for gconf dirs"
	find  /etc/gconf/ -type d -exec chmod ugo+rx "{}" \;

	einfo "changing permissions for gconf files"
	find  /etc/gconf/ -type f -exec chmod ugo+r "{}" \;
}

kill_gconf() {
	# This function will kill all running gconfd-2 that could be causing troubles
	if [ -x /usr/bin/gconftool-2 ]
	then
		/usr/bin/gconftool-2 --shutdown
	fi

	return 0
}
