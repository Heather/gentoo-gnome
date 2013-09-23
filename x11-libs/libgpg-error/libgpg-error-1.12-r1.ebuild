# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit libtool eutils multilib-minimal

DESCRIPTION="Contains error handling functions used by GnuPG software"
HOMEPAGE="http://www.gnupg.org/related_software/libgpg-error"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="common-lisp nls static-libs"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="nls? ( sys-devel/gettext )"

src_prepare() {
	elibtoolize

	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_enable common-lisp languages)
}

multilib_src_install() {
	default

	# library has no dependencies, so it does not need the .la file
	find "${D}" -name '*.la' -delete

	if multilib_is_native_abi; then
		# Move files back.
		if path_exists -o "${ED}"/tmp/gpg-error-config.*; then
			mv "${ED}"/tmp/gpg-error-config.* "${ED}"/usr/bin || die
		fi
	else
		# Preserve ABI-variant of gpg-error-config,
		# then drop all the executables
		mkdir -p "${ED}"/tmp || die
		mv "${ED}"/usr/bin/gpg-error-config "${ED}"/tmp/gpg-error-config.${ABI} || die
		rm -r "${ED}"/usr/bin || die
	fi
}
