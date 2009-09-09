# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils git python nsplugins

MY_PN="PackageKit"

DESCRIPTION="Manage packages in a secure way using a cross-distro and cross-architecture API"
HOMEPAGE="http://www.packagekit.org/"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/${PN}/${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="" # live ebuild
IUSE="connman +consolekit cron doc gtk mono networkmanager nls nsplugin pm-utils
+policykit qt4 ruck static-libs test udev"

CDEPEND="
	connman? ( net-misc/connman )
	gtk? ( dev-libs/dbus-glib
		media-libs/fontconfig
		>=x11-libs/gtk+-2.14.0:2
		x11-libs/pango )
	mono? ( dev-dotnet/glib-sharp:2
		dev-lang/mono )
	networkmanager? ( >=net-misc/networkmanager-0.6.4 )
	nsplugin? ( dev-libs/dbus-glib
		dev-libs/glib:2
		dev-libs/nspr
		x11-libs/cairo
		>=x11-libs/gtk+-2.14.0:2
		x11-libs/pango )
	policykit? ( >=sys-auth/polkit-0.92 )
	qt4? ( >=x11-libs/qt-core-4.4.0
		>=x11-libs/qt-dbus-4.4.0
		>=x11-libs/qt-sql-4.4.0 )
	udev? ( >=sys-fs/udev-145[extras] )
	dev-db/sqlite:3
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.16.1:2
	>=sys-apps/dbus-1.3.0"
RDEPEND="${CDEPEND}
	consolekit? ( sys-auth/consolekit )
	pm-utils? ( sys-power/pm-utils )
	>=app-portage/layman-1.2.3
	>=sys-apps/portage-2.2_rc39"
DEPEND="${CDEPEND}
	doc? ( >=dev-util/gtk-doc-1.9 )
	mono? ( dev-dotnet/gtk-sharp-gapi:2 )
	nsplugin? ( >=net-libs/xulrunner-1.9.1 )
	test? ( qt4? ( dev-util/cppunit >=x11-libs/qt-gui-4.4.0 ) )
	dev-libs/libxslt
	dev-util/gtk-doc
	>=dev-util/intltool-0.35.0
	dev-util/pkgconfig
	sys-devel/gettext"

RESTRICT="test" # tests in live ebuild is not a good idea

# NOTES:
# gtk-doc, gettext and intltool are mandatory for eautoreconf

src_prepare() {
	gtkdocize || die "gtkdocize failed"
	eautoreconf
	intltoolize || die "intltoolize failed"

	# prevent pyc/pyo generation
	rm py-compile || die "rm py-compile failed"
	ln -s $(type -P true) py-compile
}

src_configure() {
	local myconf=""

	if use policykit; then
		myconf="${myconf} --with-security-framework=polkit"
	else
		myconf="${myconf} --with-security-framework=dummy"
	fi

	# localstatedir: for gentoo it's /var/lib but for $PN it's /var
	# dep-tracking,option-check,libtool-lock,strict,local: obvious reasons
	# gtk-doc: doc already built
	# command,debuginfo,gstreamer,service-packs: not supported by backend
	# man-pages: we want them
	# glib2: ebuild not available atm and exprimental
	econf \
		${myconf} \
		--localstatedir=/var \
		--disable-dependency-tracking \
		--enable-option-checking \
		--enable-libtool-lock \
		--disable-strict \
		--disable-local \
		--disable-command-not-found \
		--disable-debuginfo-install \
		--disable-gstreamer-plugin \
		--disable-service-packs \
		--disable-dummy \
		--enable-portage \
		--with-default-backend=portage \
		--enable-man-pages \
		--disable-glib2 \
		$(use_enable connman) \
		$(use_enable cron) \
		$(use_enable doc gtk-doc) \
		$(use_enable gtk gtk-module) \
		$(use_enable mono managed) \
		$(use_enable networkmanager) \
		$(use_enable nls) \
		$(use_enable nsplugin browser-plugin) \
		$(use_enable pm-utils) \
		$(use_enable qt4 qt) \
		$(use_enable ruck) \
		$(use_enable static-libs static) \
		$(use_enable test tests) \
		$(use_enable udev device-rebind)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS MAINTAINERS NEWS README RELEASE TODO || die "dodoc failed"

	if use nsplugin; then
		src_mv_plugins /usr/$(get_libdir)/mozilla/plugins
	fi

	if ! use static-libs; then
		find "${D}" -name *.la | xargs rm || die "removing .la files failed"
	fi
}

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/${PN}

	if ! use policykit; then
		ewarn "You are not using policykit, the daemon can't be considered as secure."
		ewarn "All users will be able to do anything through ${MY_PN}."
		ewarn "Please, consider rebuilding ${MY_PN} with policykit USE flag."
		ewarn "THIS IS A SECURITY ISSUE."
		ewarn ""
		ebeep
		epause 5
	fi

	if ! use consolekit; then
		ewarn "You have disabled consolekit support."
		ewarn "Even if you can run ${MY_PN} without a running ConsoleKit daemon,"
		ewarn "it is not recommanded nor supported upstream."
		ewarn ""
	fi

	ewarn "${MY_PN} live ebuild could be broken because of need of SVN version of portage."
}

pkg_prerm() {
	einfo "Removing downloaded files with ${MY_PN}..."
	[[ -d "${ROOT}"/var/cache/${MY_PN}/downloads/ ]] && \
		rm -rf /var/cache/PackageKit/downloads/*
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/${PN}
}
