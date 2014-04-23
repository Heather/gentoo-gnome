# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: gnome2.eclass
# @MAINTAINER:
# @BLURB: Provides phases for Gnome/Gtk+ based packages.
# @DESCRIPTION:
# Exports portage base functions used by ebuilds written for packages using the
# GNOME framework. For additional functions, see gnome2-utils.eclass.

inherit eutils fdo-mime autotools-utils gnome.org gnome2-utils

# @ECLASS-VARIABLE: GNOME_LIVE
# @DESCRIPTION:
# Whether or not to use git
: ${GNOME_LIVE:="$( [[ "${PV}" == 9999 ]] && echo "yes" )"}

if [[ ${GNOME_LIVE} ]] ; then
	inherit git-r3
	# @ECLASS-VARIABLE: GNOME_LIVE_MODULE
	# @DESCRIPTION:
	# Default git module name is assumed to be the same as the gnome.org module name
	# used on ftp.gnome.org. We have GNOME_ORG_MODULE because we inherit gnome.org
	: ${GNOME_LIVE_MODULE:="${GNOME_ORG_MODULE}"}

	# @ECLASS-VARIABLE: EGIT_REPO_URI
	# @DESCRIPTION:
	# git URI for the project, uses GNOME_LIVE_MODULE by default
	: "${EGIT_REPO_URI:="git://git.gnome.org/${GNOME_LIVE_MODULE}"}"

	AUTOTOOLS_AUTORECONF="yes"
	SRC_URI=""
	S="${WORKDIR}/${P}"
fi

case "${EAPI:-0}" in
	4|5)
		EXPORT_FUNCTIONS src_prepare src_configure src_install pkg_preinst pkg_postinst pkg_postrm
		;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

# @ECLASS-VARIABLE: GCONF_DEBUG
# @DEFAULT_UNSET
# @DESCRIPTION:
# Whether to handle debug or not.
# Some gnome applications support various levels of debugging (yes, no, minimum,
# etc), but using --disable-debug also removes g_assert which makes debugging
# harder. This variable should be set to yes for such packages for the eclass
# to handle it properly. It will enable minimal debug with USE=-debug.
# Note that this is most commonly found in configure.ac as GNOME_DEBUG_CHECK.


if [[ ${GCONF_DEBUG} != "no" ]]; then
	IUSE="debug"
fi


# @ECLASS-VARIABLE: GNOME_MAINTAINER_MODE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Whether to force --enable-maintainer-mode debug or not.
: ${GNOME_MAINTAINER_MODE:=""}

if [[ ${GCONF_DEBUG} != "no" ]]; then
	IUSE="debug"
fi


# @FUNCTION: gnome3_src_prepare
# @DESCRIPTION:
# Prepare environment for build, fix build of scrollkeeper documentation,
# run elibtoolize.
gnome3_src_prepare() {
	# Reset various variables inherited via the environment.
	# Causes test failures, introspection-build failures, and access violations
	# FIXME: seems to have no effect for exported variables, at least with
	# portage-2.2.0_alpha74
	unset DBUS_SESSION_BUS_ADDRESS
	unset DISPLAY
	unset GNOME_KEYRING_CONTROL
	unset GNOME_KEYRING_PID
	unset XAUTHORITY
	unset XDG_SESSION_COOKIE

	# Prevent assorted access violations and test failures
	gnome2_environment_reset

	local makefile_1="$(stat -c %Y Makefile 2>/dev/null)"

	autotools-utils_src_prepare

	local makefile_2="$(stat -c %Y Makefile 2>/dev/null)"

	if [[ ! ${GNOME_MAINTAINER_MODE} ]] && [[ ${makefile_1} != ${makefile_2} ]] ; then
		einfo "Forcing maintainer mode"
		GNOME_MAINTAINER_MODE="yes"
	fi

	if [[ ${GNOME_LIVE} ]]; then
		! [[ -e ChangeLog ]] && touch ChangeLog
	fi
}

# @FUNCTION: gnome3_src_configure
# @DESCRIPTION:
# Gnome specific configure handling
gnome3_src_configure() {
	local gnome3_confargs=()
	# Update the GNOME configuration options
	if [[ ${GCONF_DEBUG} != 'no' ]] ; then
		if use debug ; then
			gnome3_confargs+=( "--enable-debug=yes" )
		fi
	fi

	# Starting with EAPI=5, we consider packages installing gtk-doc to be
	# handled by adding DEPEND="dev-util/gtk-doc-am" which provides tools to
	# relink URLs in documentation to already installed documentation.
	# This decision also greatly helps with constantly broken doc generation.
	# Remember to drop 'doc' USE flag from your package if it was only used to
	# rebuild docs.
	if grep -q "enable-gtk-doc" "${ECONF_SOURCE:-.}"/configure ; then
		gnome3_confargs+=( "--disable-gtk-doc" )
	fi

	# Pass maintainer-mode when needed
	if grep -q "enable-maintainer-mode" "${ECONF_SOURCE:-.}"/configure; then
		if [[ ${GNOME_MAINTAINER_MODE} ]] || [[ ${AUTOTOOLS_AUTORECONF} ]]; then
			gnome3_confargs+=( "--enable-maintainer-mode" )
		else
			gnome3_confargs+=( "--disable-maintainer-mode" )
		fi
	fi

	# Pass --disable-schemas-install when possible
	if grep -q "disable-schemas-install" "${ECONF_SOURCE:-.}"/configure; then
		gnome3_confargs+=( "--disable-schemas-install" ) 
	fi

	# Pass --disable-schemas-compile when possible
	if grep -q "disable-schemas-compile" "${ECONF_SOURCE:-.}"/configure; then
		gnome3_confargs+=( "--disable-schemas-compile" ) 
	fi

	# Pass --enable-compile-warnings=minimum as we don't want -Werror* flags, bug #471336
	if grep -q "enable-compile-warnings" "${ECONF_SOURCE:-.}"/configure; then
		gnome3_confargs+=( "--enable-compile-warnings=minimum") 
	fi

	myeconfargs=( "${gnome3_confargs[@]}" "${myeconfargs[@]}" "$@" )

	autotools-utils_src_configure
}

# @FUNCTION: gnome3_src_install
# @DESCRIPTION:
# Gnome specific install. Handles typical GConf setup.
gnome3_src_install() {
	# we must delay gconf schema installation due to sandbox
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"

	autotools-utils_src_install

	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL

	einstalldocs

	# Make sure this one doesn't get in the portage db
	rm -fr "${ED}/usr/share/applications/mimeinfo.cache"
}

# @FUNCTION: gnome3_pkg_preinst
# @DESCRIPTION:
# Finds Icons, GConf and GSettings schemas for later handling in pkg_postinst
gnome3_pkg_preinst() {
	gnome2_gconf_savelist
	gnome2_icon_savelist
	gnome2_schemas_savelist
	gnome2_gdk_pixbuf_savelist
}

# @FUNCTION: gnome3_pkg_postinst
# @DESCRIPTION:
# Handle scrollkeeper, GConf, GSettings, Icons, desktop and mime
# database updates.
gnome3_pkg_postinst() {
	gnome2_gconf_install
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
	gnome2_gdk_pixbuf_update
}

# # FIXME Handle GConf schemas removal
#gnome3_pkg_prerm() {
#	gnome2_gconf_uninstall
#}

# @FUNCTION: gnome2_pkg_postrm
# @DESCRIPTION:
# Handle scrollkeeper, GSettings, Icons, desktop and mime database updates.
gnome3_pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
}
