# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="A free Worms clone"
HOMEPAGE="http://www.wormux.org/"
SRC_URI="http://download.gna.org/wormux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug nls unicode"
# I like dejavu fonts of course we can use different ones.
RDEPEND=">=dev-cpp/libxmlpp-2.6
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-fonts/dejavu
	media-libs/sdl-ttf
	media-libs/sdl-gfx
	net-misc/curl
	>=media-libs/sdl-net-1.2.6
	nls? ( virtual/libintl )
	unicode? ( dev-libs/fribidi )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# avoid the strip on install
	sed -i \
		-e "s/@INSTALL_STRIP_PROGRAM@/@INSTALL_PROGRAM@/" \
		src/Makefile.in \
		|| die "sed failed"
}

src_compile() {
	egamesconf \
		--disable-dependency-tracking \
		--disable-sdltest \
		--with-gnu-ld \
		--disable-rpath \
		--with-localedir-name="/usr/share/locale" \
		--with-font-path="/usr/share/fonts/dejavu/DejaVuSans.ttf" \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable unicode fribidi) \
		|| die "configuration failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README
	newicon data/wormux_128x128.xpm wormux.xpm
	make_desktop_entry wormux Wormux wormux.xpm
	prepgamesdirs
}
