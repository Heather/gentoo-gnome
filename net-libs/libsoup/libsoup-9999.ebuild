# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2 python
if [[ ${PV} = 9999 ]]; then
	inherit eutils gnome2-live
fi

DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="http://live.gnome.org/LibSoup"

LICENSE="LGPL-2+"
SLOT="2.4"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
fi
IUSE="debug +introspection samba ssl test"
[[ ${PV} = 9999 ]] && IUSE="${IUSE} doc"

RDEPEND="
	dev-db/sqlite:3=
    >=dev-libs/glib-2.35.0:2
	>=dev-libs/libxml2-2:2
	>=net-libs/glib-networking-2.35.3[ssl?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	samba? ( net-fs/samba )
"
DEPEND="${RDEPEND}
	=dev-lang/python-2*
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.10
	sys-devel/gettext
	virtual/pkgconfig
"
if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		doc? ( >=dev-util/gtk-doc-1.10 )"
fi
#	test? (	www-servers/apache[ssl,apache2_modules_auth_digest,apache2_modules_alias,apache2_modules_auth_basic,
#		apache2_modules_authn_file,apache2_modules_authz_host,apache2_modules_authz_user,apache2_modules_dir,
#		apache2_modules_mime,apache2_modules_proxy,apache2_modules_proxy_http,apache2_modules_proxy_connect]
#		dev-lang/php[apache2,xmlrpc]
#		net-misc/curl
#		net-libs/glib-networking[ssl])"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	if [[ ${PV} = 9999 ]]; then
		# prevent SOUP_MAINTAINER_FLAGS from getting set
		mv .git .git-bck || die

		# Patch *must* be applied conditionally (see patch for details)
		# Fix bug 268592 (upstream #573685) (build fails without gnome && doc)
		use doc && epatch "${FILESDIR}/${PN}-2.34.2-fix-build-without-gnome-with-doc.patch"
	fi

	if ! use test; then
		# don't waste time building tests (bug #226271)
		sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed failed"
	fi

	gnome2_src_prepare
}

src_configure() {
	# Disable apache tests until they are usable on Gentoo, bug #326957
	# FIXME: we need addpredict to workaround bug #324779 until
	# root cause (bug #249496) is solved
	addpredict /usr/share/snmp/mibs/.index
	gnome2_src_configure \
		--disable-static \
		--disable-tls-check \
		--without-gnome \
		--without-apache-httpd \
		$(use_enable introspection) \
		$(use_with samba ntlm-auth ${EPREFIX}/usr/bin/ntlm_auth)
}
