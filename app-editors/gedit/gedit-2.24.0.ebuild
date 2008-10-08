# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gedit/gedit-2.22.3.ebuild,v 1.6 2008/08/17 19:27:03 ford_prefect Exp $

inherit gnome2 python eutils autotools

DESCRIPTION="A text editor for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc python spell xattr"

RDEPEND=">=gnome-base/gconf-2
	xattr? ( sys-apps/attr )
	>=x11-libs/libSM-1.0
	>=dev-libs/libxml2-2.5.0
	>=dev-libs/glib-2.16
	>=x11-libs/gtk+-2.13
	>=x11-libs/gtksourceview-2.2
	spell? (
		>=app-text/enchant-1.2
		app-text/iso-codes
	)
	python? (
		>=dev-python/pygobject-2.15
		>=dev-python/pygtk-2.12
		>=dev-python/pygtksourceview-2.2
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/intltool-0.35
	>=app-text/gnome-doc-utils-0.3.2
	gnome-base/gnome-common
	doc? ( dev-util/gtk-doc )"
# gnome-common needed to eautoreconf

DOCS="AUTHORS BUGS ChangeLog MAINTAINERS NEWS README"

if [[ "${ARCH}" == "PPC" ]] ; then
	# HACK HACK HACK: someone fix this garbage
	MAKEOPTS="${MAKEOPTS} -j1"
fi

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		$(use_enable python)
		$(use_enable spell)
		$(use_enable xattr attr)"
}

src_unpack() {
	gnome2_src_unpack

	# Remove symbols that are not meant to be part of the docs, and
	# break compilation if USE="doc -python" (bug #158638).
	if use !python && use doc; then
		epatch "${FILESDIR}"/${PN}-2.16.2-no_python_module_docs.patch
	fi

	# chown on fbsd doesn't have --reference.  Bug #183691
	epatch "${FILESDIR}"/${PN}-2.18.1-fbsd.patch

	# fixes failing python test due to libtool 2.2, bug #216110
	epatch "${FILESDIR}/${PN}-2.22.1-fix-libtool-2.2.patch"

	# Remove unnecessary gnome-python dep (libgnome bindings), upstream bug 555381
	epatch "${FILESDIR}/${P}-remove-gnome-python-dep.patch"

	# disable pyc compiling
	mv "${S}"/py-compile "${S}"/py-compile.orig
	ln -s $(type -P true) "${S}"/py-compile

	eautoreconf
}

pkg_postinst() {
	use python && python_mod_optimize /usr/$(get_libdir)/gedit-2/plugins
}

pkg_postrm() {
	use python && python_mod_cleanup /usr/$(get_libdir)/gedit-2/plugins
}
