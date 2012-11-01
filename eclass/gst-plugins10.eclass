# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: gst-plugins10.eclass
# @MAINTAINER:
# gstreamer@gentoo.org
# @AUTHOR:
# Gilles Dartiguelongue <eva@gentoo.org>
# Saleem Abdulrasool <compnerd@gentoo.org>
# foser <foser@gentoo.org>
# zaheerm <zaheerm@gentoo.org>
# @BLURB: Manages build for invididual ebuild for gst-plugins.
# @DESCRIPTION:
# Eclass to make external gst-plugins emergable on a per-plugin basis and
# to solve the problem with gst-plugins generating far too much unneeded
# dependancies.
#
# GStreamer consuming applications should depend on the specific plugins they
# need as defined in their source code.
#
# In case of spider usage, obtain recommended plugins to use from Gentoo
# developers responsible for gstreamer <gstreamer@gentoo.org> or the application
# developer.

# XXX: what was GST_ORC intended for. Isn't it better to leave it to the
#      ebuild reponsability ?

inherit eutils multilib versionator

GST_EXPF=""
case "${EAPI:-0}" in
	1|2|3|4|5)
		GST_EXPF="${GST_EXPF} src_configure src_compile src_install"
		;;
	0)
		die "EAPI=\"${EAPI}\" is not supported anymore"
		;;
	*)
		die "EAPI=\"${EAPI}\" is not supported yet"
		;;
esac
EXPORT_FUNCTIONS ${GST_EXPF}

# @ECLASS-VARIABLE: GST_LA_PUNT
# @DESCRIPTION:
# Should we delete all the .la files?
# NOT to be used without due consideration.
if has "${EAPI:-0}" 0 1 2 3; then
	: ${GST_LA_PUNT:="no"}
else
	: ${GST_LA_PUNT:="yes"}
fi

# @ECLASS-VARIABLE: GST_ORC
# @DESCRIPTION:
# Ebuild supports dev-lang/orc.
: ${GST_ORC:="no"}

# @ECLASS-VARIABLE: GST_PLUGINS_BUILD
# @DESCRIPTION:
# Defines the plugins to be built.
# May be set by an ebuild and contain more than one indentifier, space
# seperated (only src_configure can handle mutiple plugins at this time).
GST_PLUGINS_BUILD=${PN/gst-plugins-/}

# @ECLASS-VARIABLE: GST_PLUGINS_BUILD_DIR
# @DESCRIPTION:
# Actual build directory of the plugin.
# Most often the same as the configure switch name.
GST_PLUGINS_BUILD_DIR=${PN/gst-plugins-/}

# @ECLASS-VARIABLE: GST_TARBALL_SUFFIX
# @DESCRIPTION:
# Most projects hosted on gstreamer.freedesktop.org mirrors provide tarballs as
# tar.bz2 or tar.xz. This eclass defaults to bz2 for EAPI 0, 1, 2, 3 and
# defaults to xz for everything else. This is because the gstreamer mirrors
# are moving to only have xz tarballs for new releases.
if has "${EAPI:-0}" 0 1 2 3; then
	: ${GST_TARBALL_SUFFIX:="bz2"}
else
	: ${GST_TARBALL_SUFFIX:="xz"}
fi

# Even though xz-utils are in @system, they must still be added to DEPEND; see
# http://archives.gentoo.org/gentoo-dev/msg_a0d4833eb314d1be5d5802a3b710e0a4.xml
if [[ ${GST_TARBALL_SUFFIX} == "xz" ]]; then
	DEPEND="${DEPEND} app-arch/xz-utils"
fi

# @ECLASS-VARIABLE: GST_ORG_MODULE
# @DESCRIPTION:
# Name of the module as hosted on gstreamer.freedesktop.org mirrors.
# Leave unset if package name matches module name.
: ${GST_ORG_MODULE:=$PN}

# @ECLASS-VARIABLE: GST_ORG_PVP
# @INTERNAL
# @DESCRIPTION:
# Major and minor numbers of the version number.
: ${GST_ORG_PVP:=$(get_version_component_range 1-2)}


DESCRIPTION="${BUILD_GST_PLUGINS} plugin for gstreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"
SRC_URI="http://gstreamer.freedesktop.org/src/${GST_ORG_MODULE}/${GST_ORG_MODULE}-${PV}.tar.${GST_TARBALL_SUFFIX}"

LICENSE="GPL-2"
SLOT="${GST_ORG_PVP}"

if [[ ${PN} != ${GST_ORG_MODULE} ]]; then
	# Do not run test phase for invididual plugin ebuilds.
	RESTRICT="test"
fi

RDEPEND="${RDEPEND}
	>=dev-libs/glib-2.6:2
	media-libs/gstreamer:${SLOT}
"

if [[ ${GST_ORC} = "yes" ]]; then
  IUSE="+orc"
	RDEPEND="${RDEPEND} orc? ( >=dev-lang/orc-0.4.6 )"
#else
# XXX: verify with old ebuilds.
# DEPEND="${DEPEND} dev-libs/liboil"
fi

# added to remove circular deps
# 6/2/2006 - zaheerm
if [[ ${PN} != ${GST_ORG_MODULE} ]]; then
	RDEPEND="${RDEPEND} media-libs/${GST_ORG_MODULE}:${SLOT}"
fi

DEPEND="${RDEPEND} ${DEPEND}
	>=sys-apps/sed-4
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

S="${WORKDIR}/${GST_ORG_MODULE}-${PV}"


# @FUNCTION: gst-plugins10_get_plugins
# @INTERNAL
# @DESCRIPTION:
# Get the list of plugins requiring external dependencies.
gst-plugins10_get_plugins() {
	# Must be called from src_prepare/src_configure
	GST_PLUGINS_LIST=$(sed -rn 's/^AG_GST_CHECK_FEATURE\((\w+),.*/ \1 /p' \
		"${S}"/configure.* | tr '[:upper:]' '[:lower:]')
}

# @FUNCTION: gst-plugins10_find_plugin_dir
# @INTERNAL
# @DESCRIPTION:
# Finds plugin build directory and cd to it.
gst-plugins10_find_plugin_dir() {
	if [[ ! -d ${S}/ext/${GST_PLUGINS_BUILD_DIR} ]]; then
		if [[ ! -d ${S}/sys/${GST_PLUGINS_BUILD_DIR} ]]; then
			ewarn "No such plugin directory"
			die
		fi
		einfo "Building system plugin ${GST_PLUGINS_BUILD_DIR} ..."
		cd "${S}"/sys/${GST_PLUGINS_BUILD_DIR}
	else
		einfo "Building external plugin ${GST_PLUGINS_BUILD_DIR} ..."
		cd "${S}"/ext/${GST_PLUGINS_BUILD_DIR}
	fi
}

# @FUNCTION: gst-plugins10_system_link
# @DESCRIPTION:
# Walks through makefiles in order to make sure build will link against system
# librairies.
gst-plugins10_system_link() {
	local directory lib
	for directory in $@ ; do
		lib=$(basename $directory)
		sed -e "s:\$(top_builddir)gst-libs/gst/${directory}:${ROOT}/usr/$(get_libdir)/${lib}:" \
			-i Makefile.am Makefile.in
  done
}

# @FUNCTION: gst-plugins10_remove_unversioned_binaries
# @INTERNAL
# @DEPRECATED
# @DESCRIPTION:
# Remove the unversioned binaries gstreamer provides to prevent file collision
# with other slots.
gst-plugins10_remove_unversioned_binaries() {
	cd "${D}"/usr/bin
	local gst_bins
	for gst_bins in *-${SLOT} ; do
		[[ -e ${gst_bins} ]] || continue
		rm ${gst_bins/-${SLOT}/}
		einfo "Removed ${gst_bins/-${SLOT}/}"
	done
}

# @FUNCTION: gst-plugins10_src_configure
gst-plugins10_src_configure() {
	local plugin gst_conf

	gst-plugins10_get_plugins

	for plugin in ${GST_PLUGINS_LIST} ; do
		gst_conf="${gst_conf} --disable-${plugin}"
	done

	for plugin in ${GST_PLUGINS_BUILD} ; do
		gst_conf="${gst_conf} --enable-${plugin}"
	done

	if grep -q "ORC_CHECK" configure.* ; then
		if [[ ${GST_ORC} = "yes" ]]; then
			gst_conf="${gst_conf} $(use_enable orc)"
    else
			gst_conf="${gst_conf} --disable-orc"
		fi
	else
		if [[ ${GST_ORC} = "yes" ]]; then
			eqawarn "This ebuild declares supporting USE=orc but does not."
			eqawarn "Please report this as a bug at http://bugs.gentoo.org/"
		fi
	fi

	if grep -q "AM_MAINTAINER_MODE" configure.* ; then
		gst_conf="${gst_conf} --disable-maintainer-mode"
	fi

	if grep -q "disable-schemas-compile" configure ; then
		gst_conf="${gst_conf} --disable-schemas-compile"
	fi

	einfo "Configuring to build ${GST_PLUGINS_BUILD} plugin(s) ..."
	econf \
		--with-package-name="Gentoo GStreamer ebuild" \
		--with-package-origin="http://www.gentoo.org" \
		${gst_conf} $@
}

# @FUNCTION: gst-plugins10_src_compile
gst-plugins10_src_compile() {
	gst-plugins10_find_plugin_dir

	if has "${EAPI:-0}" 0 1 2 3 ; then
		emake || die
	else
		default
	fi
}

# @FUNCTION: gst-plugins10_src_install
gst-plugins10_src_install() {
	gst-plugins10_find_plugin_dir

	if has "${EAPI:-0}" 0 1 2 3 ; then
		emake install DESTDIR="${D}" || die
		[[ -e README ]] && dodoc README
	else
		default
	fi

	[[ ${GST_LA_PUNT} = "yes" ]] && prune_libtool_files --modules
}

