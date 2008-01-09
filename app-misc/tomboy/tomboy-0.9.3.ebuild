# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/tomboy/tomboy-0.8.2.ebuild,v 1.1 2007/12/05 23:33:51 eva Exp $

inherit gnome2 mono eutils

DESCRIPTION="Desktop note-taking application"
HOMEPAGE="http://www.beatniksoftware.com/tomboy/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc eds galago"

RDEPEND=">=dev-lang/mono-1.2
		 >=dev-dotnet/gtk-sharp-2
		 >=dev-dotnet/gconf-sharp-2
		 >=dev-dotnet/gnome-sharp-2
		 >=sys-apps/dbus-0.90
		 >=x11-libs/gtk+-2.6.0
		 >=dev-libs/atk-1.2.4
		 >=gnome-base/gconf-2
		 >=app-text/gtkspell-2.0.9
		 >=gnome-base/gnome-panel-2.8.2
		 >=gnome-base/libgnomeprint-2.2
		 >=gnome-base/libgnomeprintui-2.2
		 eds? ( dev-libs/gmime )
		 galago? ( =dev-dotnet/galago-sharp-0.5* )"
DEPEND="${RDEPEND}
		  dev-libs/libxml2
		  sys-devel/gettext
		  dev-util/pkgconfig
		>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog INSTALL NEWS README"

pkg_setup() {
	if ! built_with_use 'dev-libs/libxml2' 'python' ; then
		eerror "Please build libxml2 with the python USE-flag"
		einfo "echo \"dev-libs/libxml2 python\" >> /etc/portage/package.use"
		die "dev-libs/libxml2 without python bindings detected"
	fi

	if use eds && ! built_with_use 'dev-libs/gmime' mono ; then
		eerror "Please build gmime with the mono USE-flag"
		einfo "echo \"dev-libs/gmime mono\" >> /etc/portage/package.use"
		die "gmime without mono support detected"
	fi

	G2CONF="${G2CONF} $(use_enable galago) $(use_enable eds evolution)"
}
