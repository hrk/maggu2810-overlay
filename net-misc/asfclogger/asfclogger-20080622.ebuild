# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion

# short description
DESCRIPTION="ASFCLogger creates readable HTML file structures of aMule ASFC
	files (created by aMule with darknrg patchsets enabled)"

# link to homepage
HOMEPAGE="https://darknrg.dyndns.org:28514"

# license(s)
LICENSE="GPL-2"

# slot (0 for none)
SLOT="0"

# platform keywords
KEYWORDS="~amd64 ~x86"

# restrict downloading from mirror
RESTRICT="mirror"

# use flags
IUSE="debug"

# real name of package
# (used for archive filename-creation,
# svn module during checkout and
# part of emerge workdir)
MY_PN="ASFCLogger"

# common dependencies
COMMON_DEP="
	net-libs/htmlout"

# dependencies needed for runtime
RDEPEND="
	${COMMON_DEP}"

# dependencies needed for build time
DEPEND="
	${COMMON_DEP}"

# Code that should be executed between bootstrapping and building
before_compile() {
	:
}

# Code that should be executed between main class detection
# and java launcher creation
before_install() {
	:
}


##############################################
########## END-OF-USER-CONFIG cpp ############
##############################################


S=${WORKDIR}/${MY_PN}

[ ${#MY_PN} -eq 0 ] && MY_PN=${PN}

[ "${PV}" != "9999" ] && \
	SRC_URI="https://darknrg.dyndns.org:28514/files/pkgs/${MY_PN}-${PV}.tar.bz2"

ESVN_REPO_URI="svn+ssh://darknrg.dyndns.org/var/svn/repos/trunk/root/${MY_PN}"

src_unpack() {
	[ "${PV}" == "9999" ] && subversion_src_unpack || unpack ${A}
}

src_compile() {
	[ -d ${MY_PN} ] && cd ${MY_PN}
	[ -e bootstrap ] && ./bootstrap
	econf `use_enable debug` || die
	before_compile || die
	emake || die
}

src_install() {
	[ -d ${MY_PN} ] && cd ${MY_PN}
	before_install || die
	emake DESTDIR=${D} install || die
}