# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="C++ interface for gnome panel"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-cpp/gconfmm-2.4
	>=dev-cpp/glibmm-2.4
	>=dev-cpp/gtkmm-2.4
	>=gnome-base/gnome-panel-2.14"
DEPEND=">=dev-lang/perl-5"
