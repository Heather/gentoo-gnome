# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libgnomeuimm/libgnomeuimm-2.26.0.ebuild,v 1.1 2009/05/10 22:28:47 eva Exp $

inherit gnome2 eutils

DESCRIPTION="C++ bindings for libgnomeui"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1"
SLOT="2.6"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=gnome-base/libgnomeui-2.7.1
	>=dev-cpp/libgnomemm-2.16.0
	>=dev-cpp/libgnomecanvasmm-2.6
	>=dev-cpp/gconfmm-2.6
	>=dev-cpp/libglademm-2.4
	>=dev-cpp/gnome-vfsmm-2.16"

DEPEND=">=dev-util/pkgconfig-0.12.0
	${RDEPEND}"

DOCS="AUTHORS ChangeLog NEWS INSTALL TODO"
