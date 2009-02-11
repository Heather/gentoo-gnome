# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libwnck/libwnck-2.24.2.ebuild,v 1.1 2008/11/27 02:50:57 leio Exp $

inherit gnome2 eutils

DESCRIPTION="A window navigation construction kit"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND=">=x11-libs/gtk+-2.11.3
		 >=dev-libs/glib-2.13.0
		 >=x11-libs/startup-notification-0.4
		 x11-libs/libX11
		 x11-libs/libXres
		 x11-libs/libXext"
DEPEND="${RDEPEND}
		sys-devel/gettext
		>=dev-util/pkgconfig-0.9
		>=dev-util/intltool-0.40
		doc? ( >=dev-util/gtk-doc-1.9 )"

DOCS="AUTHORS ChangeLog HACKING NEWS README"
