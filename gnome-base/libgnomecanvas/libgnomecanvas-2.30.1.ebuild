# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit virtualx gnome2

EAPI=2

DESCRIPTION="The Gnome 2 Canvas library"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc glade"

RDEPEND=">=x11-libs/gtk+-2.13
	>=media-libs/libart_lgpl-2.3.8
	>=x11-libs/pango-1.0.1
	glade? ( >=gnome-base/libglade-2 )"

DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.18
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"

G2CONF="${G2CONF} $(use_enable glade)"

src_prepare() {
	# Fix intltoolize broken file, see upstream #577133
	# TODO: report upstream their translations are broken (intltool)
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed failed"
}

src_test() {
	Xmake check || die "Test phase failed"
}
