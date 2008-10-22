# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/epiphany/epiphany-2.22.3-r10.ebuild,v 1.1 2008/07/06 11:19:35 eva Exp $

inherit gnome2 eutils multilib

DESCRIPTION="GNOME webbrowser based on the mozilla rendering engine"
HOMEPAGE="http://www.gnome.org/projects/epiphany/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="avahi doc networkmanager python spell webkit"

# This revision is meant to work with xulrunner 1.9, an earlier revision
# is the earlier stable candidate against xulrunner-1.8 and co.

RDEPEND=">=dev-libs/glib-2.18.0
	>=x11-libs/gtk+-2.14.0
	>=dev-libs/libxml2-2.6.12
	>=dev-libs/libxslt-1.1.7
	>=gnome-base/libglade-2.3.1
	>=gnome-base/libgnome-2.14
	>=gnome-base/libgnomeui-2.14
	>=gnome-base/gnome-desktop-2.9.91
	>=x11-libs/startup-notification-0.5
	>=x11-libs/libnotify-0.4
	>=media-libs/libcanberra-0.3
	>=dev-libs/dbus-glib-0.71
	>=gnome-base/gconf-2
	>=app-text/iso-codes-0.35
	avahi? ( >=net-dns/avahi-0.6.22 )
	networkmanager? ( net-misc/networkmanager )
	webkit? ( net-libs/webkit-gtk )
	!webkit? ( =net-libs/xulrunner-1.9* )
	python? (
		>=dev-lang/python-2.3
		>=dev-python/pygtk-2.7.1
		>=dev-python/gnome-python-2.6
	)
	spell? ( app-text/enchant )
	x11-themes/gnome-icon-theme"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	>=app-text/gnome-doc-utils-0.3.2
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README TODO"

pkg_setup() {
	# FIXME: I'm automagic
	if ! built_with_use media-libs/libcanberra gtk; then
		eerror "You need to rebuild media-libs/libcanberra with gtk support."
		die "Rebuild media-libs/libcanberra with USE='gtk'"
	fi

	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--enable-certificate-manager
		--with-distributor-name=Gentoo
		$(use_enable avahi zeroconf)
		$(use_enable networkmanager network-manager)
		$(use_enable spell spell-checker)
		$(use_enable python)"

	if use webkit; then
		G2CONF="${G2CONF} --with-engine=webkit"
	else
		G2CONF="${G2CONF} --with-gecko=libxul-embedding"
	fi
}

src_compile() {
	if ! use webkit; then
		addpredict /usr/$(get_libdir)/xulrunner-1.9/components/xpti.dat
		addpredict /usr/$(get_libdir)/xulrunner-1.9/components/xpti.dat.tmp
		addpredict /usr/$(get_libdir)/xulrunner-1.9/components/compreg.dat.tmp

		# Why are these write-opened per bug 228589?
		addpredict /usr/$(get_libdir)/mozilla/components/xpti.dat
		addpredict /usr/$(get_libdir)/mozilla/components/xpti.dat.tmp
	fi

	gnome2_src_compile
}
