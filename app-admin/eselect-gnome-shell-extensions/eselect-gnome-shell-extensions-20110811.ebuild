# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Manages system defaults for GNOME Shell extensions"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# gnome-shell schemas are used in pkg_postinst
COMMON_DEPEND="app-admin/eselect
	>=dev-libs/glib-2.26:2
	gnome-base/gsettings-desktop-schemas
	gnome-base/gnome-shell"
RDEPEND="${COMMON_DEPEND}
	dev-lang/perl
	dev-perl/JSON"
DEPEND="${COMMON_DEPEND}"
S="${WORKDIR}" # for now, since installing from ${FILESDIR}

src_install() {
	insinto "/usr/share/eselect/modules"
	newins "${FILESDIR}/${PV}.eselect" "gnome-shell-extensions.eselect"
	keepdir "/etc/eselect/gnome-shell-extensions"
	# The actual gschema override file will be greated in pkg_postinst.
	dosym "/etc/eselect/gnome-shell-extensions/${PN}.gschema.override" \
		"/usr/share/glib-2.0/schemas/"
}

pkg_postinst() {
	einfo "Updating list of installed extensions"
	eselect gnome-shell-extensions update || die
	elog
	elog "eselect gnome-shell-extensions manages the system default value of"
	elog "the org.gnome.shell disabled-extensions key. To override the default"
	elog "for an individual user, use the gsettings command, e.g."
	elog "\$ gsettings set org.gnome.shell disabled-extensions \"['foo', 'bar']\""
	elog "To undo per-user changes and use the system default, do"
	elog "\$ gsettings reset org.gnome.shell disabled-extensions"
	elog
}
