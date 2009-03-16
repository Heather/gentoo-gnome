# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Themes for the Murrine GTK+2 Cairo Engine"
HOMEPAGE="http://www.cimitan.com/murrine/"

URI_PREFIX="http://www.cimitan.com/murrine/files"
SRC_URI="${URI_PREFIX}/MurrinaBlu-0.32.tar.gz
${URI_PREFIX}/MurrinaCandido.tar.gz
${URI_PREFIX}/MurrinaGilouche.tar.bz2
${URI_PREFIX}/MurrinaVerdeOlivo.tar.bz2
${URI_PREFIX}/MurrinaFancyCandy.tar.bz2
${URI_PREFIX}/MurrinaLoveGray.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	dodir /usr/share/themes
	insinto /usr/share/themes
	doins -r "${WORKDIR}"/Murrin* || die "Installing themes failed!"
}
