# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/anjuta/anjuta-2.26.2.2.ebuild,v 1.3 2009/07/09 22:16:15 eva Exp $

EAPI="2"

inherit autotools eutils gnome2 flag-o-matic

DESCRIPTION="A versatile IDE for GNOME"
HOMEPAGE="http://www.anjuta.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="debug devhelp doc glade sourceview subversion +symbol-db test"

# FIXME: Anjuta has some CRITICAL and WARNINGS messages, that would be nice to fix them and/or report on upstream
RDEPEND=">=dev-libs/glib-2.16
	>=x11-libs/gtk+-2.14
	>=gnome-base/orbit-2.6
	>=gnome-base/gconf-2.12
	>=x11-libs/vte-0.13.1
	>=dev-libs/libxml2-2.4.23
	>=dev-libs/gdl-2.27.1
	>=app-text/gnome-doc-utils-0.3.2
	>=x11-libs/libwnck-2.12
	>=dev-libs/libunique-1
	symbol-db? (
		gnome-extra/libgda:4
		dev-util/ctags )

	dev-libs/libxslt
	>=dev-lang/perl-5
	dev-perl/Locale-gettext
	sys-devel/autogen

	devhelp? (
		>=dev-util/devhelp-0.22
		>=net-libs/webkit-gtk-1 )
	glade? ( >=dev-util/glade-3.6.0 )
	sourceview? (
		>=x11-libs/gtk+-2.10
		>=gnome-base/libgnome-2.14
		>=x11-libs/gtksourceview-2.4 )
	subversion? (
		>=dev-util/subversion-1.5.0
		>=net-misc/neon-0.28.2
		>=dev-libs/apr-1
		>=dev-libs/apr-util-1 )"
DEPEND="${RDEPEND}
	!!dev-libs/gnome-build
	>=sys-devel/gettext-0.14
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.20
	>=app-text/scrollkeeper-0.3.14-r2
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.4 )
	test? (
		~app-text/docbook-xml-dtd-4.1.2
		~app-text/docbook-xml-dtd-4.5 )"

DOCS="AUTHORS ChangeLog FUTURE MAINTAINERS NEWS README ROADMAP THANKS TODO"

pkg_setup() {
	if ! use symbol-db; then
		elog "You disabled symbol-db which will disallow using projects."
	fi

	G2CONF="${G2CONF}
		--docdir=/usr/share/doc/${PF}
		$(use_enable debug)
		$(use_enable devhelp plugin-devhelp)
		$(use_enable glade plugin-glade)
		$(use_enable sourceview plugin-sourceview)
		$(use_enable subversion plugin-subversion)
		$(use_enable symbol-db plugin-symbol-db)"

	# Conflics wiht -pg in a plugin, bug #266777
	filter-flags -fomit-frame-pointer
}

src_prepare() {
	gnome2_src_prepare

	# Make Symbol DB optional
	epatch "${FILESDIR}/${PN}-2.28.1.0-symbol-db-optional.patch"
	# Do not force the debugging mode when --disable-debug
	# is given on the command line.
	epatch "${FILESDIR}/${P}-debug-mode.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

src_install() {
	# Anjuta uses a custom rule to install DOCS, get rid of it
	gnome2_src_install
	rm -rf "${D}"/usr/share/doc/${PN} || die "rm failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	ebeep 1
	elog ""
	elog "Some project templates may require additional development"
	elog "libraries to function correctly. It goes beyond the scope"
	elog "of this ebuild to provide them."
	epause 5
}
