# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Original Author: Arun Raghavan <ford_prefect@gentoo.org> (based on the
#		   gnome-python-desktop eclass by Jim Ramsay <lack@gentoo.org>)
#
# Purpose: Provides common functionality required for building the gnome-python*
# 		   bindings
#
# Important environment variables:
#
# G_PY_PN: Which gnome-python* package bindings we're working with. Defaults to
#		   gnome-python if unset.
#
# G_PY_BINDINGS: The actual '--enable-<binding>' name, which by default is ${PN}
# 		   excluding the -python at the end. May be overridden if necessary.
#
# EXAMPLES: The set of example files to be installed if the 'examples' USE flag
# 		   is set.
#
# The naming convention for all bindings is as follows:
#	dev-python/<original-${PN}-for-which-this-is-the-binding>-python
#
# So, for example, with the bonobo bindings, the original package is libbonobo
# and the packages is named dev-python/libbonobo-python

inherit autotools gnome2 python versionator

G_PY_PN=${G_PY_PN:-gnome-python}
G_PY_BINDINGS=${G_PY_BINDINGS:-${PN%-python}}

PVP="$(get_version_component_range 1-2)"
SRC_URI="mirror://gnome/sources/${G_PY_PN}/${PVP}/${G_PY_PN}-${PV}.tar.bz2"
HOMEPAGE="http://pygtk.org/"

RESTRICT="${RESTRICT} test"

GCONF_DEBUG="no"
DOCS="AUTHORS ChangeLog NEWS README"

if [[ ${G_PY_PN} != "gnome-python" ]]; then
	DOCS="${DOCS} MAINTAINERS"
fi

S="${WORKDIR}/${G_PY_PN}-${PV}"

# add blockers, we can probably remove them later on
if [[ ${G_PY_PN} == "gnome-python-extras" ]]; then
	RDEPEND="!<=dev-python/gnome-python-extras-2.19.1-r2"
fi

RDEPEND="${RDEPEND} ~dev-python/${G_PY_PN}-base-${PV}"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

# Enable the required bindings as specified by the G_PY_BINDINGS variable
gnome-python-common_pkg_setup() {
	G2CONF+=" --disable-allbindings"
	for binding in ${G_PY_BINDINGS}; do
		G2CONF+=" --enable-${binding}"
	done
}

gnome-python-common_src_unpack() {
	if ! has "${EAPI:-0}" 0 1 || [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
		die "${FUNCNAME}() cannot be used in this EAPI"
	fi

	gnome2_src_unpack
	has "${EAPI:-0}" 0 1 && gnome-python-common_src_prepare
}

# gnome-python-common_src_prepare() must be called at the end of src_prepare().
gnome-python-common_src_prepare() {
	gnome2_src_prepare

	# disable pyc compiling
	if [[ -f py-compile ]]; then
		rm py-compile
		ln -s $(type -P true) py-compile
	fi

	if [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
		python_copy_sources
	fi
}

gnome-python-common_src_configure() {
	if [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
		python_execute_function -s gnome2_src_configure
	else
		gnome2_src_configure
	fi
}

gnome-python-common_src_compile() {
	if [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
		python_src_compile
	else
		default
	fi
}

# Do a regular gnome2 src_install and then install examples if required.
# Set the variable EXAMPLES to provide the set of examples to be installed.
# (to install a directory recursively, specify it with a trailing '/' - for
# example, foo/bar/)
gnome-python-common_src_install() {
	gnome-python-common_installation() {
		# The .pc file is installed by respective gnome-python*-base package
		sed -i '/^pkgconfig_DATA/d' Makefile || die "sed failed"
		sed -i '/^pkgconfigdir/d' Makefile || die "sed failed"

		gnome2_src_install
	}

	if [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
		python_execute_function -s gnome-python-common_installation
	else
		gnome-python-common_installation
	fi

	if hasq examples ${IUSE} && use examples; then
		insinto /usr/share/doc/${PF}/examples

		for example in ${EXAMPLES}; do
			if [[ ${example: -1} = "/" ]]; then
				doins -r ${example}
			else
				doins ${example}
			fi
		done
	fi

	python_clean_sitedirs
}

gnome-python-common_pkg_postinst() {
	if ! has "${EAPI:-0}" 0 1 2 || [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
		python_mod_optimize gtk-2.0
	else
		python_need_rebuild
		python_mod_optimize $(python_get_sitedir)/gtk-2.0
	fi
}

gnome-python-common_pkg_postrm() {
	if ! has "${EAPI:-0}" 0 1 2 || [[ -n "${SUPPORT_PYTHON_ABIS}" ]]; then
		python_mod_cleanup gtk-2.0
	else
		python_mod_cleanup $(python_get_sitedir)/gtk-2.0
	fi
}

case "${EAPI:-0}" in
	0|1)
		EXPORT_FUNCTIONS pkg_setup src_unpack src_install pkg_postinst pkg_postrm
		;;
	*)
		EXPORT_FUNCTIONS pkg_setup src_prepare src_configure src_compile src_install pkg_postinst pkg_postrm
		;;
esac
