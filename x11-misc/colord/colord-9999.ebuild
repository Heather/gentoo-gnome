# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit base
if [[ ${PV} = 9999 ]]; then
	GCONF_DEBUG="no"
	inherit gnome2-live # need all the hacks from gnome2-live_src_prepare
fi

DESCRIPTION="System service to accurately color manage input and output devices"
HOMEPAGE="http://colord.hughsie.com/"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://gitorious.org/colord/master.git"
else
	SRC_URI="http://www.freedesktop.org/software/colord/releases/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE="doc examples +introspection scanner +udev vala"

# XXX: raise to libusb-1.0.9:1 when available
COMMON_DEPEND="
	dev-db/sqlite:3
	>=dev-libs/glib-2.28.0:2
	>=dev-libs/libusb-1.0.8:1
	>=media-libs/lcms-2.2:2
	>=sys-auth/polkit-0.97
	introspection? ( >=dev-libs/gobject-introspection-0.9.8 )
	scanner? ( media-gfx/sane-backends )
	udev? ( || ( sys-fs/udev[gudev] sys-fs/udev[extras] ) )
"
RDEPEND="${COMMON_DEPEND}
	media-gfx/shared-color-profiles"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-sgml-utils
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	dev-util/pkgconfig
	>=sys-devel/gettext-0.17
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1.9
	)
	vala? ( dev-lang/vala:0.12 )
"

# FIXME: needs pre-installed dbus service files
RESTRICT="test"

DOCS=(AUTHORS ChangeLog MAINTAINERS NEWS README TODO)

src_configure() {
	if use vala; then
		if use introspection; then
			export VAPIGEN=$(type -p vapigen-0.12)
		else
			ewarn "Vala bindings cannot be built because the introspection USE flag is disabled"
		fi
	fi
	econf \
		--disable-examples \
		--disable-static \
		--enable-polkit \
		--enable-reverse \
		$(use_enable doc gtk-doc) \
		$(use_enable scanner sane) \
		$(use_enable udev gudev)
	# parallel make fails in doc/api
	use doc && MAKEOPTS=-j1
}

src_install() {
	base_src_install

	# additional documentation files not included in tarball releases
	[[ ${PV} = 9999 ]] && use doc && dodoc doc/*.txt doc/*.svg

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.c
	fi

	find "${D}" -name "*.la" -delete
}
