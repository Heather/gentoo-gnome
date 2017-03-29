# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2

DESCRIPTION="The GNOME panel applets"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="acpi apm doc gnome gstreamer ipv6 networkmanager"

#ver old depends!
RDEPEND=">=x11-libs/gtk+-2.13
	>=dev-libs/glib-2.18.0
	>=gnome-base/gconf-2.8
	>=gnome-base/gnome-panel-2.13.4
	>=x11-libs/libxklavier-2.91
	>=x11-libs/libwnck-2.9.3
	>=gnome-base/gnome-desktop-2.11.1
	>=x11-libs/libnotify-0.3.2
	>=sys-apps/dbus-1.1.2
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/libxml2-2.5.0
	>=dev-libs/libgweather-2.22.1
	apm? ( sys-apps/apmd )
	x11-libs/libX11
	gnome?	(
		>=gnome-base/libgnomekbd-2.21.4.1
		gnome-base/gnome-settings-daemon

		>=gnome-extra/gucharmap-2.23
		>=gnome-base/libgtop-2.11.92

		>=dev-python/pygobject-3.24 )
	gstreamer?	(
		>=media-libs/gstreamer-0.10.2
		>=media-libs/gst-plugins-base-0.10.14
		|| (
			>=media-plugins/gst-plugins-alsa-0.10.14
			>=media-plugins/gst-plugins-oss-0.10.14 ) )
	networkmanager? ( >=net-misc/networkmanager-0.7.0 )"

DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/pkgconfig-0.19
	>=dev-util/intltool-0.35
	dev-libs/libxslt
	~app-text/docbook-xml-dtd-4.3
	doc? ( app-text/docbook-sgml-utils )"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile

	# Make it libtool-1 compatible, bug #266248
	rm -v m4/lt* m4/libtool.m4 || die "removing libtool macros failed"

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-scrollkeeper
		--disable-schemas-install
		--enable-flags
		$(use_enable gstreamer mixer-applet)
		$(use_enable ipv6)
		$(use_enable networkmanager)
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check || die "emake check failed"
}

src_install() {
	gnome2_src_install

	local APPLETS="accessx-status battstat charpick cpufreq drivemount geyes
			 gkb-new gswitchit gweather invest-applet mini-commander
			 mixer modemlights multiload null_applet stickynotes trashapplet"

	# modemlights is out because it needs system-tools-backends-1

	for applet in ${APPLETS} ; do
		docinto ${applet}

		for d in AUTHORS ChangeLog NEWS README README.themes TODO ; do
			[ -s ${applet}/${d} ] && dodoc ${applet}/${d}
		done
	done
}

pkg_postinst() {
	gnome2_pkg_postinst

	# check for new python modules on bumps
	python_mod_optimize $(python_get_sitedir)/invest
}
