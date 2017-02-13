# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
WANT_AUTOCONF="2.1"
PYTHON_COMPAT=( python2_{6,7} )
PYTHON_REQ_USE="threads"
inherit autotools eutils toolchain-funcs multilib python-any-r1 versionator pax-utils

MY_PN="mozjs"
MY_PV="${PV/_alpha/a}"
MY_PV="${PV/_beta/b}"
MY_P="${MY_PN}-${MY_PV/_/.}"
DESCRIPTION="Stand-alone JavaScript C library"
HOMEPAGE="http://www.mozilla.org/js/spidermonkey/"
SRC_URI="https://people.mozilla.org/~sstangl/mozjs-31.2.0.rc0.tar.bz2"

LICENSE="NPL-1.1"
SLOT="31"

#broken
#KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"

IUSE="debug +jit icu minimal static-libs +system-icu test"

RESTRICT="ia64? ( test )"
REQUIRED_USE="debug? ( jit )"

S="${WORKDIR}/${MY_P%.rc*}"
BUILDDIR="${WORKDIR}/jsbuild"

RDEPEND=">=dev-libs/nspr-4.9.4
	virtual/libffi
	>=sys-libs/zlib-1.1.4
	system-icu? ( >=dev-libs/icu-1.51:= )"

#TODO: patch for 4.3 sed
#patch example: https://github.com/MeisterP/torbrowser-overlay/commit/df66b67f8786cf931b3711cd444ab4d2ce35e174
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	<sys-apps/sed-4.3
	app-arch/zip
	virtual/pkgconfig"

pkg_setup(){
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		python-any-r1_pkg_setup
		export LC_ALL="C"
	fi
}


src_prepare() {
	epatch "${FILESDIR}"/mozjs31-1021171.patch
	epatch "${FILESDIR}"/mozjs31-1037470.patch
	epatch "${FILESDIR}"/mozjs31-1046176.patch
	epatch "${FILESDIR}"/mozjs31-1119228.patch
	epatch_user
}

src_configure() {
	mkdir "${BUILDDIR}" && cd "${BUILDDIR}" || die

        local myopts=""
        if use icu; then # make sure system-icu flag only affects icu-enabled build
                myopts+="$(use_with system-icu)"
        else
                myopts+="--without-system-icu"
        fi

	CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
	AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" \
	LD="$(tc-getLD)" \
	ECONF_SOURCE="${S}/js/src" \
	econf ${myopts} \
		--disable-trace-malloc \
		--enable-jemalloc \
		--enable-readline \
		--enable-threadsafe \
		--with-system-nspr \
		--enable-system-ffi \
		--disable-optimize \
		$(use_with icu intl-api) \
		$(use_enable debug) \
		$(use_enable jit ion) \
		$(use_enable jit yarr-jit) \
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
	cd "${BUILDDIR}/js/src/jsapi-tests" || die
	emake check
	cd "${BUILDDIR}" || die
	emake check-jit-test
}

src_install() {
	cd "${BUILDDIR}" || die
	emake DESTDIR="${D}" install

	if ! use minimal; then
		if use jit; then
			pax-mark m "${ED}/usr/bin/js${SLOT}"
		fi
	else
		rm -f "${ED}/usr/bin/js${SLOT}"
	fi

	rm -f "${ED}/usr/bin/js"
	rm -f "${ED}/usr/bin/js-config"

	if ! use static-libs; then
		# We can't actually disable building of static libraries
		# They're used by the tests and in a few other places
		find "${D}" -iname '*.a' -delete || die
	fi

	insinto /usr/include/mozjs-31
	doins ${WORKDIR}/mozjs-31.2.0/js/src/*.h
	doins ${WORKDIR}/mozjs-31.2.0/js/src/*.msg
	doins ${WORKDIR}/mozjs-31.2.0/js/src/perf/*.h
	doins ${BUILDDIR}/js/src/*.h

	insinto /usr/include/mozjs-31/js/
	doins ${WORKDIR}/mozjs-31.2.0/js/public/*

	insinto /usr/include/mozjs-31/mozilla
	doins ${WORKDIR}/mozjs-31.2.0/mfbt/*.h
	doins ${WORKDIR}/mozjs-31.2.0/mfbt/decimal/*.h
}
