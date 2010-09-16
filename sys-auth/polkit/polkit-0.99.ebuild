# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/polkit/polkit-0.96-r2.ebuild,v 1.6 2010/08/14 17:08:08 armin76 Exp $

EAPI="2"

inherit autotools eutils multilib pam

DESCRIPTION="Policy framework for controlling privileges for system-wide services"
HOMEPAGE="http://hal.freedesktop.org/docs/PolicyKit"
SRC_URI="http://hal.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc examples +introspection nls pam"

# not mature enough
RDEPEND=">=dev-libs/glib-2.25.12
	dev-libs/expat
	introspection? ( dev-libs/gobject-introspection )
	pam? ( virtual/pam )"
DEPEND="${RDEPEND}
	!!>=sys-auth/policykit-0.92
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	>=dev-util/pkgconfig-0.18
	>=dev-util/intltool-0.36
	doc? ( >=dev-util/gtk-doc-1.13 )"
PDEPEND=">=sys-auth/consolekit-0.4[policykit]"
# gtk-doc-am-1.13 needed for eautoreconf

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.96-getcwd.patch"
}

src_configure() {
	local conf

	if use pam; then
		conf="${conf} --with-authfw=pam
			--with-pam-module-dir=$(getpam_mod_dir)"
	else
		conf="${conf} --with-authfw=shadow"
	fi

	# We define libexecdir due to fdo bug #22951
	# easier to maintain than patching everything
	econf ${conf} \
		--disable-ansi \
		--disable-examples \
		--enable-fast-install \
		--enable-libtool-lock \
		--enable-man-pages \
		--disable-dependency-tracking \
		--with-os-type=gentoo \
		--localstatedir=/var \
		--libexecdir='${exec_prefix}/libexec/polkit-1' \
		$(use_enable debug verbose-mode) \
		$(use_enable doc gtk-doc) \
		$(use_enable introspection) \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc NEWS README AUTHORS ChangeLog || die "dodoc failed"

	# We disable example compilation above, and handle it here
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins src/examples/{*.c,*.policy*}
	fi

	# Need to keep a few directories around...
	diropts -m0700 -o root -g root
	keepdir /var/run/polkit-1
	keepdir /var/lib/polkit-1
}

pkg_postinst() {
	# Make sure that the user has consolekit sessions working so that the
	# 'allow_active' directive in polkit action policies works
	if has_version 'gnome-base/gdm' && ! has_version 'gnome-base/gdm[consolekit]'; then
		# If user has GDM installed, but USE=-consolekit, warn them
		ewarn "You have GDM installed, but it does not have USE=consolekit"
		ewarn "If you login using GDM, polkit authorizations will not work"
		ewarn "unless you enable USE=consolekit"
		einfo
	fi
	if has_version 'kde-base/kdm' && ! has_version 'kde-base/kdm[consolekit]'; then
		# If user has KDM installed, but USE=-consolekit, warn them
		ewarn "You have KDM installed, but it does not have USE=consolekit"
		ewarn "If you login using KDM, polkit authorizations will not work"
		ewarn "unless you enable USE=consolekit"
		einfo
	fi
	if ! has_version 'gnome-base/gdm[consolekit]' && \
		! has_version 'kde-base/kdm[consolekit]'; then
		# Inform user about the alternative method
		ewarn "If you don't use GDM or KDM for logging in,"
		ewarn "you must start your desktop environment (DE) as follows:"
		ewarn "	ck-launch-session \$STARTGUI"
		ewarn "Where \$STARTGUI is a DE-starting command such as 'gnome-session'."
		ewarn "You should add this to your ~/.xinitrc if you use startx."
	fi
}
