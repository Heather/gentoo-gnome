# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Python 3 used for g-ir-merge script
PYTHON_COMPAT=( python3_{5,6,7} )

inherit bash-completion-r1 gnome.org linux-info python-any-r1 meson vala

DESCRIPTION="A tagging metadata database, search tool and indexer"
HOMEPAGE="https://wiki.gnome.org/Projects/Tracker"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/100"
IUSE="elibc_glibc icu kernel_linux networkmanager stemmer systemd test"
RESTRICT="test"

KEYWORDS="~amd64 ~x86"

# glibc-2.12 needed for SCHED_IDLE (see bug #385003)
RDEPEND="
	>=dev-db/sqlite-3.8.3:=
	>=dev-libs/glib-2.58.0:2
	>=dev-libs/gobject-introspection-1.0:=
	icu? ( >=dev-libs/icu-4.8.1.1:= )
	!icu? ( dev-libs/libunistring )
	>=dev-libs/json-glib-1.0
	>=dev-libs/libxml2-2.6
	>=net-libs/libsoup-2.40:2.4
	>sys-apps/dbus-1.3.1

	elibc_glibc? ( >=sys-libs/glibc-2.12 )
	networkmanager? ( >=net-misc/networkmanager-0.8:= )
	stemmer? ( dev-libs/snowball-stemmer )
	systemd? ( sys-apps/systemd )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	>=dev-util/gtk-doc-am-1.8
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"
PDEPEND=""

function inotify_enabled() {
	if linux_config_exists; then
		if ! linux_chkconfig_present INOTIFY_USER; then
			ewarn "You should enable the INOTIFY support in your kernel."
			ewarn "Check the 'Inotify support for userland' under the 'File systems'"
			ewarn "option. It is marked as CONFIG_INOTIFY_USER in the config"
			die 'missing CONFIG_INOTIFY'
		fi
	else
		einfo "Could not check for INOTIFY support in your kernel."
	fi
}

pkg_setup() {
	linux-info_pkg_setup
	inotify_enabled

	python-any-r1_pkg_setup
}

src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dbash_completion="$(get_bashcompdir)"
		-Ddocs=true
		-Dfts=true
		-Dfunctional_tests=false
		-Dnetwork_manager=$(usex networkmanager yes no)
		-Dstemmer=$(usex stemmer yes no)
		-Dsystemd_user_services=$(usex systemd yes no)
	)
	if use icu; then
		emesonargs+=(-Dunicode_support=icu)
	else
		emesonargs+=(-Dunicode_support=unistring)
	fi
	meson_src_configure
}
