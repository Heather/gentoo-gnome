# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="yes" # Not gnome macro but similar
GNOME2_LA_PUNT="yes"

inherit gnome2 pam versionator virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="https://live.gnome.org/GnomeKeyring"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+caps debug doc pam selinux"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
fi

RDEPEND="
	>=app-crypt/gcr-3.5.3
	>=dev-libs/glib-2.32.0:2
	>=x11-libs/gtk+-3.0:3
	app-misc/ca-certificates
	>=dev-libs/libgcrypt-1.2.2
	>=sys-apps/dbus-1.0
	caps? ( sys-libs/libcap-ng )
	pam? ( virtual/pam )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"
PDEPEND=">=gnome-base/libgnome-keyring-3.1.92"
# eautoreconf needs:
#	>=dev-util/gtk-doc-am-1.9
# gtk-doc-am is not needed otherwise (no gtk-docs are installed)

src_prepare() {
	# Disable stupid CFLAGS
	sed -e 's/CFLAGS="$CFLAGS -g"//' \
		-e 's/CFLAGS="$CFLAGS -O0"//' \
		-i configure.ac configure || die

	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		$(use_with caps libcap-ng)
		$(use_enable pam)
		$(use_with pam pam-dir $(getpam_mod_dir))
		$(use_enable selinux)
		--with-root-certs=${EPREFIX}/etc/ssl/certs/
		--with-ca-certificates=${EPREFIX}/etc/ssl/certs/ca-certificates.crt
		--enable-ssh-agent
		--enable-gpg-agent"
	gnome2_src_configure
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check
}

pkg_postinst() {
	use caps && fcaps 0:0 755 cap_ipc_lock "${ROOT}"/usr/bin/gnome-keyring-daemon

	gnome2_pkg_postinst
}

# borrowed from GSoC2010_Gentoo_Capabilities by constanze and Flameeyes
# @FUNCTION: fcaps
# @USAGE: fcaps {uid:gid} {file-mode} {cap1[,cap2,...]} {file}
# @RETURN: 0 if all okay; non-zero if failure and fallback
# @DESCRIPTION:
# fcaps sets the specified capabilities in the effective and permitted set of
# the given file. In case of failure fcaps sets the given file-mode.
# Requires versionator.eclass
fcaps() {
	local uid_gid=$1
	local perms=$2
	local capset=$3
	local path=$4
	local res

	chmod $perms $path && \
	chown $uid_gid $path
	res=$?

	use caps || return $res

	#set the capability
	setcap "$capset=ep" "$path" &> /dev/null
	#check if the capability got set correctly
	setcap -v "$capset=ep" "$path" &> /dev/null
	res=$?

	if [ $res -ne 0 ]; then
		ewarn "Failed to set capabilities. Probable reason is missing kernel support."
		ewarn "Your kernel must have <FS>_FS_SECURITY enabled (e.g. EXT4_FS_SECURITY)"
		ewarn "where <FS> is the filesystem to store ${path}"
		if ! version_is_at_least 2.6.33 "$(uname -r)"; then
			ewarn "For kernel 2.6.32 or older, you will also need to enable"
			ewarn "SECURITY_FILE_CAPABILITIES."
		fi
		ewarn
		ewarn "Falling back to suid now..."
		chmod u+s ${path}
	fi
	return $res
}
