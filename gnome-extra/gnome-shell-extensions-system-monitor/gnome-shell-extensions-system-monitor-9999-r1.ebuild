# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

EGIT_REPO_URI="git://github.com/paradoxxxzero/gnome-shell-system-monitor-applet"

inherit eutils gnome2-utils gnome2-live

DESCRIPTION="System monitor extension for GNOME Shell"
HOMEPAGE="https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="" #"~amd64 ~x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.26
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gnome-shell
	gnome-base/libgtop[introspection]
	media-libs/clutter:1.0[introspection]
	net-misc/networkmanager[introspection]
	x11-libs/gtk+:3[introspection]
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.26
	sys-devel/gettext
	virtual/pkgconfig
	gnome-base/gnome-common
"

src_prepare() { :; }

src_configure() { :; }

src_compile() {
	local locale
	for locale in ${LINGUAS}
	do
		[[ ! -d po/${locale} ]] && continue
		mkdir -p locale/${locale}/LC_MESSAGES
		msgfmt po/${locale}/system-monitor.po -o locale/${locale}/LC_MESSAGES/system-monitor.mo || die
	done
}

src_install()	{
	insinto /usr/share/gnome-shell/extensions/system-monitor@paradoxxx.zero.gmail.com
	doins system-monitor@paradoxxx.zero.gmail.com/*.{css,js,json}

	insinto /usr/share
	doins -r "${S}"/system-monitor@paradoxxx.zero.gmail.com/locale

	insinto /usr/share/glib-2.0/schemas
	doins system-monitor@paradoxxx.zero.gmail.com/schemas/*.gschema.xml
}

pkg_postinst() {
	gnome2_pkg_postinst

	einfo "Updating list of installed extensions"
	eselect gnome-shell-extensions update || die
	elog
	elog "Installed extensions installed are initially disabled by default."
	elog "To change the system default and enable some extensions, you can use"
	elog "# eselect gnome-shell-extensions"
	elog "Alternatively, you can use the org.gnome.shell disabled-extensions"
	elog "gsettings key to change the disabled extension list per-user."
	elog
}
