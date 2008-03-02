# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/sabayon/sabayon-2.20.1-r1.ebuild,v 1.7 2008/02/03 11:43:06 armin76 Exp $

inherit gnome2 eutils python multilib pam

DESCRIPTION="Tool to maintain user profiles in a GNOME desktop"
HOMEPAGE="http://www.gnome.org/projects/sabayon/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

# Unfortunately the configure.ac is wildly insufficient, so dependencies have
# to be got from the RPM .spec file...
DEPEND="dev-lang/python
	>=x11-libs/gtk+-2.6.0
	>=dev-python/pygtk-2.5.3
	x11-libs/pango
	dev-python/python-ldap
	x11-base/xorg-server"

RDEPEND="${DEPEND}
	virtual/pam
	dev-python/pyxdg
	app-admin/gamin
	dev-libs/libxml2
	>=gnome-base/gconf-2.8.1
	>=dev-python/gnome-python-2.6.0
	x11-libs/gksu"

DOCS="AUTHORS ChangeLog ISSUES NEWS README TODO"

pkg_setup() {
	if built_with_use x11-base/xorg-server minimal; then
		eerror "${PN} needs Xnest, which the minimal USE flag disables."
		eerror "Please re-emerge x11-base/xorg-xserver with USE=-minimal"
		die "need x11-base/xorg-xserver built without minimal USE flag"
	fi
	if ! built_with_use dev-libs/libxml2 python; then
		eerror "${PN} needs the python bindings to libxml2."
		eerror "Please re-emerge dev-libs/libxml2 with USE=python"
		die "need dev-libs/libxml2 built with python USE flag"
	fi
	# dang: I don't think this should happen...  Python is a system dep
	if ! python_mod_exists gamin; then
		# app-admin/gamin (0.1.7, at least) lacks "python" USE flag even though
		# it builds python bindings. That's not good, hackers. That's not good.
		eerror "${PN} needs the python bindings to gamin. Please re-emerge"
		eerror "app-admin/gamin, and ensure the python bindings are built."
		die "need python bindings to app-admin/gamin"
	fi

	G2CONF="--with-distro=gentoo \
		--with-prototype-user=${PN}-admin \
		--enable-console-helper=no \
		--with-pam-prefix=$(getpam_mod_dir)"

	einfo "Adding user '${PN}-admin' as the prototype user"
	# I think /var/lib/sabayon is the correct directory to use here.
	enewgroup ${PN}-admin
	enewuser ${PN}-admin -1 -1 "/var/lib/sabayon" "${PN}-admin"
	# Should we delete the user/group on unmerge?
}

src_unpack() {
	gnome2_src_unpack

	# Switch gnomesu to gksu; bug #197865
	sed -i -e 's/gnomesu/gksu/' admin-tool/sabayon.desktop || die "gksu sed failed"
	sed -i -e 's/gnomesu/gksu/' admin-tool/sabayon.desktop.in || die "gksu sed failed"

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

pkg_postinst() {
	gnome2_pkg_postinst

	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/sabayon

	# unfortunately /etc/gconf is CONFIG_PROTECT_MASK'd
	elog "To apply Sabayon defaults and mandatory settings to all users, put"
	elog '    include "$(HOME)/.gconf.path.mandatory"'
	elog "in /etc/gconf/2/local-mandatory.path and put"
	elog '    include "$(HOME)/.gconf.path.defaults"'
	elog "in /etc/gconf/2/local-defaults.path."
	elog "You can safely create these files if they do not already exist."
}

pkg_postrm() {
	gnome2_pkg_postrm

	python_version
	python_mod_cleanup /usr/$(get_libdir)/python${PYVER}/site-packages/sabayon
}
