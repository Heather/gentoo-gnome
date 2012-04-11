# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="yes"
GNOME_ORG_MODULE="GConf"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2
if [[ ${PV} = 9999 ]]; then
	GNOME_LIVE_MODULE="gconf"
	inherit gnome2-live
fi

DESCRIPTION="Gnome Configuration System and Daemon"
HOMEPAGE="http://projects.gnome.org/gconf/"

LICENSE="LGPL-2"
SLOT="2"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
fi
IUSE="debug doc +introspection ldap orbit policykit"

RDEPEND=">=dev-libs/glib-2.31:2
	>=x11-libs/gtk+-2.90:3
	>=dev-libs/dbus-glib-0.74
	>=sys-apps/dbus-1
	>=dev-libs/libxml2-2:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	ldap? ( net-nds/openldap )
	orbit? ( >=gnome-base/orbit-2.4:2 )
	policykit? ( sys-auth/polkit )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--enable-gtk
		--disable-static
		--enable-gsettings-backend
		--with-gtk=3.0
		$(use_enable introspection)
		$(use_with ldap openldap)
		$(use_enable orbit)
		$(use_enable policykit defaults-service)
		ORBIT_IDL=$(type -P orbit-idl-2)"
		# Need host's IDL compiler for cross or native build, bug #262747
	kill_gconf
}

src_prepare() {
	gnome2_src_prepare

	# Do not start gconfd when installing schemas, fix bug #238276, upstream #631983
	epatch "${FILESDIR}/${PN}-2.24.0-no-gconfd.patch"

	# Do not crash in gconf_entry_set_value() when entry pointer is NULL, upstream #631985
	epatch "${FILESDIR}/${PN}-2.28.0-entry-set-value-sigsegv.patch"
}

src_install() {
	gnome2_src_install

	keepdir /etc/gconf/gconf.xml.mandatory
	keepdir /etc/gconf/gconf.xml.defaults
	# Make sure this directory exists, bug #268070, upstream #572027
	keepdir /etc/gconf/gconf.xml.system

	echo 'CONFIG_PROTECT_MASK="/etc/gconf"' > 50gconf
	echo 'GSETTINGS_BACKEND="gconf"' >> 50gconf
	doenvd 50gconf || die "doenv failed"
	dodir /root/.gconfd || die
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
