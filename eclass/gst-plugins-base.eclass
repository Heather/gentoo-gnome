# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: gst-plugins-base.eclass
# @MAINTAINER:
# gstreamer@gentoo.org
# @AUTHOR:
# Gilles Dartiguelongue <eva@gentoo.org>
# Saleem Abdulrasool <compnerd@gentoo.org>
# foser <foser@gentoo.org>
# zaheerm <zaheerm@gentoo.org>
# @BLURB: Manages build for invididual ebuild for gst-plugins-base.
# @DESCRIPTION:
# See gst-plugins10.eclass documentation.

GST_ORG_MODULE="gst-plugins-base"

inherit eutils gst-plugins10 multilib

case ${EAPI:-0} in
	1|2|3|4|5)
		;;
	0)
		die "EAPI=\"${EAPI}\" is not supported anymore"
		;;
	*)
		die "EAPI=\"${EAPI}\" is not supported yet"
		;;
esac


# @FUNCTION: gst-plugins-base_src_prepare
# @DESCRIPTION:
# Makes sure build will use system librairies.
#gst-plugins-base_src_prepare() {
#
#	# Link with the syswide installed gst-libs if needed
#	gst-plugins10_find_plugin_dir
#	gst-plugins10_system_link (
#		'interfaces/libgstinterfaces'
#		'audio/libgstaudio'
#		'cdda/libgstcdda'
#		'riff/libgstriff'
#		'tag/libgsttag'
#		'video/libgstvideo'
#		'netbuffer/libgstnetbuffer'
#		'rtp/libgstrtp'
#	)
#}

