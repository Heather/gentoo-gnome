# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/sysprof/sysprof-1.0.12-r1.ebuild,v 1.1 2009/05/27 11:02:05 remi Exp $

inherit eutils linux-info

DESCRIPTION="System-wide Linux Profiler"
HOMEPAGE="http://www.daimi.au.dk/~sandmann/sysprof/"
SRC_URI="http://www.daimi.au.dk/~sandmann/sysprof/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.6
	>=x11-libs/gtk+-2.6
	x11-libs/pango
	>=gnome-base/libglade-2"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

pkg_setup() {
	kernel_is -ge 2 6 31 || \
		die "Sysprof will not work with a kernel version less than 2.6.31"
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README TODO

	# Insert icons in the proper place
	for i in 16 24 32 48; do
		insinto "/usr/share/icons/hicolor/${i}x${i}/apps"
		newins "${S}/sysprof-icon-${i}.png" sysprof.png
		rm "${D}/usr/share/pixmaps/sysprof-icon-${i}.png" || die "rm $i failed!"
	done
	newicon "${S}/sysprof-icon-48.png" sysprof.png
	make_desktop_entry sysprof Sysprof sysprof
}

pkg_postinst() {
	einfo "On many systems, especially amd64, it is typical that with a modern"
	einfo "toolchain -fomit-frame-pointer for gcc is the default, because"
	einfo "debugging is still possible thanks to gcc4/gdb location list feature."
	einfo "However sysprof is not able to construct call trees if frame pointers"
	einfo "are not present. Therefore -fno-omit-frame-pointer CFLAGS is suggested"
	einfo "for the libraries and applications involved in the profiling. That"
	einfo "means a CPU register is used for the frame pointer instead of other"
	einfo "purposes, which means a very minimal performance loss when there is"
	einfo "register pressure."
}
