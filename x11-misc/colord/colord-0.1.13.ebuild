# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils base
if [[ ${PV} = 9999 ]]; then
	GCONF_DEBUG="no"
	inherit gnome2-live # need all the hacks from gnome2-live_src_prepare
fi

DESCRIPTION="System service to accurately color manage input and output devices"
HOMEPAGE="http://www.freedesktop.org/software/colord/"
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
IUSE="doc examples +introspection scanner +udev"

# FIXME: raise to libusb-1.0.9:1 when available
COMMON_DEPEND="
	dev-db/sqlite:3
	>=dev-libs/glib-2.28.0:2
	>=dev-libs/libusb-1.0.8:1
	>=media-libs/lcms-2.2:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.8 )
	scanner? ( media-gfx/sane-backends )
	udev? ( || ( sys-fs/udev[gudev] sys-fs/udev[extras] ) )
"
RDEPEND="${COMMON_DEPEND}
	media-gfx/shared-color-profiles"
# Automagic build-time vala dependency if USE=introspection
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	dev-util/pkgconfig
	>=sys-devel/gettext-0.17
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1.9
	)
	introspection? ( dev-lang/vala:0.14 )
"

# FIXME: needs pre-installed dbus service files
RESTRICT="test"

DOCS=(AUTHORS ChangeLog MAINTAINERS NEWS README TODO)

pkg_setup() {
	enewgroup colord
	enewuser colord -1 -1 /var/lib/colord colord
}

src_prepare() {
	# Ubuntu patch to allow root and at_console to access colord without polkit;
	# this behavior matches upstream default polkit settings.
	epatch "${FILESDIR}/${PN}-0.1.13-use-dbus-security-for-permissions.patch"
	gnome2_src_prepare
}

src_configure() {
	# Disable polkit to allow registering devices when colord is running as
	# non-root; https://bugs.launchpad.net/ubuntu/+source/colord/+bug/837851
	econf \
		--disable-examples \
		--disable-static \
		--disable-polkit \
		--enable-reverse \
		--disable-volume-search \
		--with-daemon-user=colord \
		--localstatedir="${EPREFIX}"/var \
		$(use_enable doc gtk-doc) \
		$(use_enable introspection) \
		$(use_enable scanner sane) \
		$(use_enable udev gudev) \
		VAPIGEN=$(type -p vapigen-0.14)
	# parallel make fails in doc/api
	use doc && MAKEOPTS=-j1
}

src_install() {
	base_src_install

	# Ensure config and profile directories exist and are writable
	local d
	for d in /var/lib/{color,colord}; do
		keepdir "${d}"
		fowners colord:colord "${d}"
	done

	# additional documentation files not included in tarball releases
	[[ ${PV} = 9999 ]] && use doc && dodoc doc/*.txt doc/*.svg

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.c
	fi

	find "${D}" -name "*.la" -delete || die
}

pkg_postinst() {
	# <=colord-0.1.11 ran as root and used /var/lib/lib/colord to store
	# configuration files and /var/lib/lib/color for custom color profiles.
	local old_dir="${EROOT}var/lib/lib/colord"
	local new_dir="${EROOT}var/lib/colord"

	if [[ -e "${old_dir}/mapping.db" || -e "${old_dir}/storage.db" ]] && \
	   ! [[ -e "${new_dir}/mapping.db" || -e "${new_dir}/storage.db" ]]; then
		elog "Old colord configuration files are present in ${old_dir}. If you"
		elog "are upgrading from colord-0.1.11 or older and had previously"
		elog "customized your color management settings, you will need to copy"
		elog "these files to ${new_dir} and then change the file ownership"
		elog "to colord:colord :"
		elog
		elog " # cp ${old_dir}/*.db ${new_dir}"
		elog " # chown colord:colord ${new_dir}/*.db"
		elog
	fi
	old_dir="${EROOT}var/lib/lib/color"
	new_dir="${EROOT}var/lib/color"
	if [[ -e "${old_dir}/icc" && ! -e "${new_dir}/icc" ]]; then
		elog "Old custom color profiles are present in ${old_dir}. If you are"
		elog "upgrading from colord-0.1.11 or older, you will need to copy them"
		elog "to ${new_dir} and then change the ownership to colord:colord :"
		elog
		elog " # cp -r ${old_dir}/icc ${new_dir}"
		elog " # chown -R colord:colord ${new_dir}/icc"
		elog
	fi
}
