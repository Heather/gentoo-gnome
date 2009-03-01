# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXrandr/libXrandr-1.2.3.ebuild,v 1.1 2008/07/05 06:28:05 dberkholz Exp $

# Must be before x-modular eclass is inherited
# SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org Xrandr library"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	>=x11-proto/randrproto-1.2.99.3
	x11-proto/xproto"
DEPEND="${RDEPEND}
	x11-proto/renderproto"
