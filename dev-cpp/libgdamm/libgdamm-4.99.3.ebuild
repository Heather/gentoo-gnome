# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libgdamm/libgdamm-4.1.1.ebuild,v 1.2 2011/02/17 10:15:01 pacho Exp $

EAPI="4"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="C++ bindings for libgda"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="berkdb doc"

RDEPEND=">=dev-cpp/glibmm-2.27.93:2
	>=gnome-extra/libgda-4.99.2:5[berkdb=]"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

pkg_setup() {
	# Automagic libgda-berkdb support
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF} $(use_enable doc documentation)"
}

src_prepare() {
	# Note: the libgda-4.99.3 requirement in configure is an obvious typo.
	# The main change in libgdamm-4.99.3 is suport for new semantics introduced
	# in libgda-4.99.2 API. In addition, libgdamm-4.99.3 was released a few
	# hours after libgda-4.99.2, i.e. at the time when there was no difference
	# between libgda git master (future 4.99.3) and the libgda 4.99.2 release.
	sed -e 's:libgda-5.0 >= 4.99.3:libgda-5.0 >= 4.99.2:' \
		-i configure.ac configure || die "sed configure.ac configure failed"
	gnome2_src_prepare
}
