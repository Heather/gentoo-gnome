# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Pantheon DE meta package"
HOMEPAGE="https://elementary.io/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64"
IUSE="bluetooth cups networkmanager +minimal pulseaudio upower"

DEPEND=""
RDEPEND="${DEPEND}
	bluetooth? (
		pantheon-base/switchboard-plug-bluetooth
		pantheon-base/wingpanel-indicator-bluetooth
	)
	cups? ( pantheon-base/switchboard-plug-printers )
	!minimal? (
		pantheon-extra/pantheon-calculator
		pantheon-extra/pantheon-calendar
		pantheon-extra/pantheon-camera
		pantheon-extra/pantheon-code
		pantheon-extra/pantheon-music
		pantheon-extra/pantheon-photos
		pantheon-extra/pantheon-print
		pantheon-extra/pantheon-screenshot
		pantheon-extra/pantheon-videos
	)
	networkmanager? (
		pantheon-base/switchboard-plug-network
		pantheon-base/wingpanel-indicator-network
	)
	pantheon-base/pantheon-files
	pantheon-base/pantheon-shell
	pantheon-base/switchboard-plug-a11y
	pantheon-base/switchboard-plug-about
	pantheon-base/switchboard-plug-applications
	pantheon-base/switchboard-plug-datetime
	pantheon-base/switchboard-plug-display
	pantheon-base/switchboard-plug-keyboard
	pantheon-base/switchboard-plug-locale
	pantheon-base/switchboard-plug-mouse-touchpad
	pantheon-base/switchboard-plug-notifications
	pantheon-base/switchboard-plug-pantheon-shell
	pantheon-base/switchboard-plug-parental-controls
	pantheon-base/switchboard-plug-security-privacy
	pantheon-base/switchboard-plug-sharing
	pantheon-base/switchboard-plug-useraccounts
	pantheon-base/wingpanel-indicator-ally
	pantheon-base/wingpanel-indicator-datetime
	pantheon-base/wingpanel-indicator-keyboard
	pantheon-base/wingpanel-indicator-notifications
	pantheon-base/wingpanel-indicator-session
	pantheon-extra/elementary-tweaks
	pulseaudio? (
		pantheon-base/switchboard-plug-sound
		pantheon-base/wingpanel-indicator-sound
	)
	upower? (
		pantheon-base/switchboard-plug-power
		pantheon-base/wingpanel-indicator-power
	)
	x11-misc/lightdm
	x11-terms/pantheon-terminal
"
