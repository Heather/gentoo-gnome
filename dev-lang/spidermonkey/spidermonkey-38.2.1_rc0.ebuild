# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
WANT_AUTOCONF="2.1"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"
inherit autotools eutils toolchain-funcs multilib python-any-r1 versionator pax-utils

MY_PN="mozjs"
MY_P="${MY_PN}-${PV/_/.}"
DESCRIPTION="Stand-alone JavaScript C library"
HOMEPAGE="https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey"
SRC_URI="https://people.mozilla.org/~sstangl/${MY_P}.tar.bz2"

LICENSE="NPL-1.1"
SLOT="38"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="debug icu jit minimal static-libs test"

RESTRICT="ia64? ( test )"

S="${WORKDIR}/mozjs-38.0.0"
BUILDDIR="${S}/js/src"

RDEPEND=">=dev-libs/nspr-4.9.4
	virtual/libffi
	sys-libs/readline:0=
	>=sys-libs/zlib-1.1.4"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	<sys-apps/sed-4.3
	dev-libs/icu
	app-arch/zip
	virtual/pkgconfig"

pkg_setup(){
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		python-any-r1_pkg_setup
		export LC_ALL="C"
	fi
}

src_prepare() {
	#mystical Fedora patch
	epatch "${FILESDIR}"/mozbz-1143022.patch
	epatch_user

	if [[ ${CHOST} == *-freebsd* ]]; then
		# Don't try to be smart, this does not work in cross-compile anyway
		ln -sfn "${BUILDDIR}/config/Linux_All.mk" "${S}/config/$(uname -s)$(uname -r).mk" || die
	fi

	cd "${BUILDDIR}" || die
	eautoconf
}

src_configure() {
	export SHELL=/bin/sh
	cd "${BUILDDIR}" || die

	CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
	AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" \
	LD="$(tc-getLD)" \
	econf \
		--enable-jemalloc \
		--enable-readline \
		--enable-threadsafe \
		--with-system-nspr \
		--enable-system-ffi \
		--disable-optimize \
		$(use_enable icu intl-api) \
		$(use_enable debug) \
		$(use_enable jit yarr-jit) \
		$(use_enable jit ion) \
		$(use_enable static-libs static) \
		$(use_enable test tests)
}

cross_make() {
	emake \
		CFLAGS="${BUILD_CFLAGS}" \
		CXXFLAGS="${BUILD_CXXFLAGS}" \
		AR="${BUILD_AR}" \
		CC="${BUILD_CC}" \
		CXX="${BUILD_CXX}" \
		RANLIB="${BUILD_RANLIB}" \
		"$@"
}
src_compile() {
	cd "${BUILDDIR}" || die
	if tc-is-cross-compiler; then
		tc-export_build_env BUILD_{AR,CC,CXX,RANLIB}
		cross_make \
			MOZ_OPTIMIZE_FLAGS="" MOZ_DEBUG_FLAGS="" \
			HOST_OPTIMIZE_FLAGS="" MODULE_OPTIMIZE_FLAGS="" \
			MOZ_PGO_OPTIMIZE_FLAGS="" \
			host_jsoplengen host_jskwgen
		cross_make \
			MOZ_OPTIMIZE_FLAGS="" MOZ_DEBUG_FLAGS="" HOST_OPTIMIZE_FLAGS="" \
			-C config nsinstall
		mv {,native-}host_jskwgen || die
		mv {,native-}host_jsoplengen || die
		mv config/{,native-}nsinstall || die
		sed -i \
			-e 's@./host_jskwgen@./native-host_jskwgen@' \
			-e 's@./host_jsoplengen@./native-host_jsoplengen@' \
			Makefile || die
		sed -i -e 's@/nsinstall@/native-nsinstall@' config/config.mk || die
		rm -f config/host_nsinstall.o \
			config/host_pathsub.o \
			host_jskwgen.o \
			host_jsoplengen.o || die
	fi
	emake \
		MOZ_OPTIMIZE_FLAGS="" MOZ_DEBUG_FLAGS="" \
		HOST_OPTIMIZE_FLAGS="" MODULE_OPTIMIZE_FLAGS="" \
		MOZ_PGO_OPTIMIZE_FLAGS=""
}

src_test() {
	cd "${BUILDDIR}/jsapi-tests" || die
	emake check
}

src_install() {
	cd "${BUILDDIR}" || die
	emake DESTDIR="${D}" install

	mv "${ED}/usr/bin/js" "${ED}/usr/bin/js${SLOT}" || die
	mv "${ED}/usr/bin/js-config" "${ED}/usr/bin/js${SLOT}-config" || die
	mv "${ED}/usr/lib64/pkgconfig/js.pc" "${ED}/usr/lib64/pkgconfig/mozjs-${SLOT}.pc" || die

	if ! use minimal; then
		if use jit; then
			pax-mark m "${ED}/usr/bin/js${SLOT}"
		fi
	else
		rm -f "${ED}/usr/bin/js${SLOT}"
	fi

	#terrible crap is happening here
	insinto /usr/include/mozjs-38
	doins ${WORKDIR}/mozjs-38.0.0/js/src/*.h
	doins ${WORKDIR}/mozjs-38.0.0/js/src/*.msg
	doins ${WORKDIR}/mozjs-38.0.0/js/src/perf/*.h
	doins ${BUILDDIR}/js/src/*.h

	insinto /usr/include/mozjs-38/js/
	doins ${WORKDIR}/mozjs-38.0.0/js/public/*

	insinto /usr/include/mozjs-38/mozilla
	doins ${WORKDIR}/mozjs-38.0.0/mfbt/*.h
	doins ${WORKDIR}/mozjs-38.0.0/mfbt/decimal/*.h
	doins ${WORKDIR}/mozjs-38.0.0/mfbt/double-conversion/*.h

	if ! use static-libs; then
		# We can't actually disable building of static libraries
		# They're used by the tests and in a few other places
		find "${D}" -iname '*.a' -delete || die
	fi
}
