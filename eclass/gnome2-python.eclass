# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Gilles Dartiguelongue <eva@gentoo.org>
# Purpose:
#

inherit gnome2 python

# Stolen from git.eclass
EXPORTED_FUNCTIONS="pkg_setup src_compile src_test src_install pkg_postinst pkg_postrm"
case "${EAPI:-0}" in
    2|3) EXPORTED_FUNCTIONS="${EXPORTED_FUNCTIONS} src_prepare src_configure" ;;
	0|1) ;;
	*) die "Unknown EAPI, Bug eclass maintainers." ;;
esac

EXPORT_FUNCTIONS ${EXPORTED_FUNCTIONS}

gnome2-python_pkg_setup() {
	python_pkg_setup
}

gnome2-python_src_prepare() {
	if [ -f py-compile ]; then
		# disable pyc compiling
		mv py-compile py-compile.orig
		ln -s $(type -P true) py-compile
	fi

	gnome2_src_prepare
	python_copy_sources
}

gnome2-python_src_configure() {
	configure() {
		gnome2_src_configure PYTHON=$(PYTHON -a)
	}
	python_execute_function -s configure
}

gnome2-python_src_compile() {
	python_execute_function -s gnome2_src_compile
}

gnome2-python_src_test() {
	python_execute_function -s -d
}


gnome2-python_src_install() {
	python_execute_function -s gnome2_src_install
	python_clean_installation_image
}


gnome2-python_pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize ${GNOME_ORG_MODULE}
}


gnome2-python_pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup ${GNOME_ORG_MODULE}
}
