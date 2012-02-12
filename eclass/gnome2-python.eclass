# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: gnome2-python.eclass
# @MAINTAINER:
# Gentoo GNOME Project <gnome@gentoo.org>
# Gentoo Python Project <python@gentoo.org>
# @BLURB: Eclass for GNOME Python packages supporting installation for multiple Python ABIs
# @DESCRIPTION:
# The gnome2-python eclass defines phase functions for GNOME Python packages supporting
# installation for multiple Python ABIs.

inherit gnome2 python

# Stolen from git.eclass
EXPORTED_FUNCTIONS="pkg_setup src_compile src_test src_install"
case "${EAPI:-0}" in
    2|3|4) EXPORTED_FUNCTIONS="${EXPORTED_FUNCTIONS} src_prepare src_configure" ;;
	0|1) ;;
	*) die "Unknown EAPI, bug eclass maintainers." ;;
esac

EXPORT_FUNCTIONS ${EXPORTED_FUNCTIONS}

gnome2-python_pkg_setup() {
	python_pkg_setup
}

gnome2-python_src_prepare() {
	gnome2_src_prepare
	python_clean_py-compile_files
	python_copy_sources
}

gnome2-python_src_configure() {
	configure() {
		gnome2_src_configure PYTHON=$(PYTHON -a) "$@"
	}
	python_execute_function -s configure
}

gnome2-python_src_compile() {
	python_execute_function -s gnome2_src_compile "$@"
}

gnome2-python_src_test() {
	python_execute_function -s -d
}

gnome2-python_src_install() {
	python_execute_function -s gnome2_src_install
	python_clean_installation_image
}
