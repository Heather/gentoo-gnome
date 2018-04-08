# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="Personal task manager"
HOMEPAGE="https://wiki.gnome.org/Apps/Todo"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"
SRC_URI="https://ftp.gnome.org/pub/GNOME/sources/gnome-todo/3.28/${P}.tar.xz"

RDEPEND="
	>=dev-libs/glib-2.43.4:2
	>=x11-libs/gtk+-3.22.0:3
	>=net-libs/gnome-online-accounts-3.28.0
	>=gnome-extra/evolution-data-server-3.28.0:=[gtk]
	>=dev-libs/libical-0.43
	>=dev-libs/libpeas-1.22
	>=dev-libs/gobject-introspection-1.42:=
"
DEPEND="${RDEPEND}
	>=dev-util/meson-0.40.0
	doc? ( dev-util/gtk-doc )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
#	"${FILESDIR}"/${PV}-libical3-compat.patch
)

src_configure() {
	# TODO: There aren't any consumers of the introspection outside gnome-todo's own plugins, so maybe we
	# TODO: should just always build introspection support as an application that needs it for full functionality?
	# Todoist plugin requires 3.25.3 GOA for being able to add a Todoist account
	meson_src_configure \
		-Denable-background-plugin=true \
		-Denable-dark-theme-plugin=true \
		-Denable-scheduled-panel-plugin=true \
		-Denable-score-plugin=true \
		-Denable-today-panel-plugin=true \
		-Denable-unscheduled-panel-plugin=true \
		-Denable-todo-txt-plugin=true \
		-Denable-todoist-plugin=true \
		$(meson_use doc enable-gtk-doc) \
		-Denable-introspection=true
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}
