# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/file-roller/file-roller-2.20.2.ebuild,v 1.1 2007/11/29 09:21:36 leio Exp $

inherit eutils gnome2

DESCRIPTION="archive manager for GNOME"
HOMEPAGE="http://fileroller.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="nautilus"

RDEPEND=">=dev-libs/glib-2.12
		 >=x11-libs/gtk+-2.10
		 >=gnome-base/libgnome-2.6
		 >=gnome-base/libgnomeui-2.6
		 >=gnome-base/gnome-vfs-2.10
		 >=gnome-base/libglade-2.4
		 >=gnome-base/gconf-2
		 nautilus? ( >=gnome-base/nautilus-2.10 )"
DEPEND="${RDEPEND}
		sys-devel/gettext
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.19
		>=app-text/gnome-doc-utils-0.3.2"

DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README TODO"

pkg_setup() {
	if ! use nautilus ; then
		G2CONF="${G2CONF} --disable-nautilus-actions"
	fi
}

src_unpack() {
	gnome2_src_unpack

	# Use absolute path to GNU tar since star doesn't have the same
	# options.  On Gentoo, star is /usr/bin/tar, GNU tar is /bin/tar
	epatch "${FILESDIR}"/${PN}-2.10.3-use_bin_tar.patch

	# use a local rpm2cpio script to avoid the dep
	epatch "${FILESDIR}"/${PN}-2.10-use_fr_rpm2cpio.patch
}

src_install() {
	gnome2_src_install
	dobin "${FILESDIR}"/rpm2cpio-file-roller
}

pkg_postinst() {
	elog "${PN} is a frontend for several archiving utility. If you want a"
	elog "particular achive format support, see ${HOMEPAGE}"
	elog "and install the relevant package."
	elog
	elog "for example:"
	elog "  rar   - app-arch/unrar"
	elog "  lha   - app-arch/lha"
	elog "  7-zip - app-arch/p7zip"
}
