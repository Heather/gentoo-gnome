# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-meta/gst-plugins-meta-0.10.ebuild,v 1.7 2007/11/27 15:22:59 dang Exp $

DESCRIPTION="Meta ebuild to pull in gst plugins for apps"
HOMEPAGE="http://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0.10"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="a52 alsa dvb dvd esd ffmpeg flac mad mpeg mythtv ogg oss theora vorbis X xv"

RDEPEND="a52? ( >=media-plugins/gst-plugins-a52dec-0.10 )
		 alsa? ( >=media-plugins/gst-plugins-alsa-0.10 )
		 dvb? (
				media-plugins/gst-plugins-dbb
				>=media-lib/gst-plugins-bad-0.10.6
				>=media-plugins/gst-plugins-fluendo-mpegdemux-0.10.15
			  )
		 dvd? (
				>=media-libs/gst-plugins-ugly-0.10
				>=media-plugins/gst-plugins-a52dec-0.10
				>=media-plugins/gst-plugins-dvdread-0.10
				>=media-plugins/gst-plugins-mpeg2dec-0.10
			  )
		 esd? ( >=media-plugins/gst-plugins-esd-0.10 )
		 ffmpeg? ( >=media-plugins/gst-plugins-ffmpeg-0.10 )
		 flac? ( >=media-plugins/gst-plugins-flac-0.10 )
		 mad? ( >=media-plugins/gst-plugins-mad-0.10 )
		 mpeg? ( >=media-plugins/gst-plugins-mpeg2dec-0.10 )
		 mythtv? ( media-plugins/gst-plugins-mythtv )
		 ogg? ( >=media-plugins/gst-plugins-ogg-0.10 )
		 oss? ( >=media-plugins/gst-plugins-oss-0.10 )
		 theora? (
					>=media-plugins/gst-plugins-ogg-0.10
					>=media-plugins/gst-plugins-theora-0.10
				 )
		 vorbis? (
					>=media-plugins/gst-plugins-ogg-0.10
					>=media-plugins/gst-plugins-vorbis-0.10
				 )
		 X? ( >=media-plugins/gst-plugins-x-0.10 )
		 xv? ( >=media-plugins/gst-plugins-xvideo-0.10 )"

# Usage note:
# The idea is that apps depend on this for optional gstreamer plugins.  Then,
# when USE flags change, no app gets rebuilt, and all apps that can make use of
# the new plugin automatically do.

# When adding deps here, make sure the keywords on the gst-plugin are valid.
