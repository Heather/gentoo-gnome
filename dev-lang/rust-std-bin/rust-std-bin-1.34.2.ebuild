# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils bash-completion-r1 versionator toolchain-funcs

DESCRIPTION="std libraries for rust"
HOMEPAGE="https://www.rust-lang.org/"

SRC_URI="
	abi_x86_32? ( https://static.rust-lang.org/dist/rust-std-"${PV}"-i686-unknown-linux-gnu.tar.xz )
	"

RUST_PROVIDER="rust-bin-1.37.0"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"
SLOT="stable"
KEYWORDS="amd64"
IUSE="abi_x86_32 cpu_flags_x86_sse2"

DEPEND=""
RDEPEND="app-eselect/eselect-rust
	=dev-lang/rust-bin-1.37.0-r0
	!dev-lang/rust:0"

REQUIRED_USE="x86? ( cpu_flags_x86_sse2 )"

QA_PREBUILT="
	opt/"${RUST_PROVIDER}"/lib/rustlib/*/lib/*.so
	opt/"${RUST_PROVIDER}"/lib/rustlib/*/lib/*.rlib*
"
src_unpack() {
	default
	mv "${WORKDIR}/rust-std-"${PV}"-i686-unknown-linux-gnu" "${S}" || die
}

src_install() {
	./install.sh \
		--disable-verify \
		--prefix="${D}/opt/"${RUST_PROVIDER}"" \
		--disable-ldconfig \
		|| die

	cd "${D}"/opt/"${RUST_PROVIDER}"/lib/rustlib || die
	rm install.log || die
	rm rust-installer-version || die
	rm components || die
	rm uninstall.sh || die
}

pkg_postinst() {
	eselect rust update --if-unset

}

pkg_postrm() {
	eselect rust unset --if-invalid
}
