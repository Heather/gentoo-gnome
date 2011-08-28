# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="http://www.gnome.org/"
LICENSE="as-is"
SLOT="3.0"
IUSE=""

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# New package
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=app-arch/file-roller-${PV}
	>=games-board/aisleriot-${PV}
	>=gnome-extra/bug-buddy-2.32.0:2
	>=gnome-extra/gcalctool-6.0.0
	>=gnome-extra/gconf-editor-3.0.0
	>=gnome-extra/gnome-games-${PV}
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-tweak-tool-${PV}
	>=gnome-extra/gnome-utils-${PV}
	>=gnome-extra/gucharmap-3.0.0:2.90
	>=mail-client/evolution-${PV}
	>=media-sound/sound-juicer-2.99
	>=media-video/cheese-3.0.0
	>=net-analyzer/gnome-nettool-3.0.0
	>=net-misc/vinagre-${PV}
	>=net-misc/vino-${PV}
	>=www-client/epiphany-3.0.0
"
# Re-add when it stops using outdated libraries like gnome-vfs
#>=media-gfx/shotwell-0.8.1
# Note: bug-buddy is broken with GNOME 3
DEPEND=""
S=${WORKDIR}
