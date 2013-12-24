# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="http://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+games +tracker"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~amd64 ~x86"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# New package
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=app-admin/gnome-system-log-3.9.90
	>=app-arch/file-roller-${PV}
	>=app-dicts/gnome-dictionary-3.9.0
	>=app-misc/bijiben-${PV}
	>=gnome-extra/gconf-editor-3
	>=gnome-extra/gnome-calculator-3.10.0
	>=gnome-extra/gnome-clocks-${PV}
	>=gnome-extra/gnome-power-manager-${PV}
	>=gnome-extra/gnome-search-tool-3.6
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-tweak-tool-3.10.0
	>=gnome-extra/gnome-weather-${PV}
	>=gnome-extra/gucharmap-3.9.99:2.90
	>=gnome-extra/nautilus-sendto-3.8.1
	>=gnome-extra/sushi-3.10.0
	>=mail-client/evolution-${PV}
	>=media-gfx/gnome-font-viewer-3.10.0
	>=media-gfx/gnome-photos-${PV}
	>=media-gfx/gnome-screenshot-3.10.0
	>=media-sound/gnome-music-${PV}
	>=media-sound/sound-juicer-3.5.0
	>=media-video/cheese-${PV}
	>=net-analyzer/gnome-nettool-3.2
	>=net-misc/vino-${PV}
	>=net-misc/vinagre-${PV}
	>=sci-geosciences/gnome-maps-3.10.0
	>=sys-apps/baobab-3.10
	>=sys-apps/gnome-disk-utility-3.10.0
	>=www-client/epiphany-${PV}

	tracker? (
		>=app-misc/tracker-0.16
		>=gnome-extra/gnome-documents-3.10.0
		>=net-misc/gnome-online-miners-3.10.0 )

	games? (
		>=games-arcade/gnome-nibbles-${PV}
		>=games-arcade/gnome-robots-3.10.0
		>=games-board/aisleriot-3.2.3.2
		>=games-board/four-in-a-row-${PV}
		>=games-board/gnome-chess-${PV}
		>=games-board/gnome-mahjongg-${PV}
		>=games-board/gnome-mines-${PV}
		>=games-board/iagno-${PV}
		>=games-board/tali-3.10.0
		>=games-puzzle/five-or-more-${PV}
		>=games-puzzle/gnome-klotski-3.10.0
		>=games-puzzle/gnome-sudoku-${PV}
		>=games-puzzle/gnome-tetravex-${PV}
		>=games-puzzle/lightsoff-${PV}
		>=games-puzzle/quadrapassel-3.10.0
		>=games-puzzle/swell-foop-${PV} )
"
# Temporarily removed from RDEPEND. Put them back once version bumped to 3.10
#	>=gnome-extra/gnome-packagekit-${PV}

# Note: bug-buddy is broken with GNOME 3
# Note: aisleriot-3.4 is masked for guile-2
DEPEND=""
S=${WORKDIR}
