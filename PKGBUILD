# Maintainer:  Håvard Pettersson <mail@haavard.me>
# Contributor: Sergej Pupykin <pupykin.s+arch@gmail.com>
# Contributor: Bartłomiej Piotrowski <bpiotrowski@archlinux.org>
# Contributor: Thorsten Töpper <atsutane-tu@freethoughts.de>
# Contributor: Thayer Williams <thayer@archlinux.org>
# Contributor: Jeff 'codemac' Mickey <jeff@archlinux.org>

_pkgname=dmenu
pkgname=$_pkgname-git
pkgver=4.9.6.g9b38fda
pkgrel=1
pkgdesc="A generic menu for X"
url="http://tools.suckless.org/dmenu/"
arch=('i686' 'x86_64')
license=('MIT')
depends=('sh' 'libxinerama' 'libxft')
makedepends=('git')
provides=($_pkgname)
conflicts=($_pkgname)
source=(git://git.suckless.org/$_pkgname
        dmenu-xft.diff
        dmenu-xresources-20200302-db6093f.diff
        )
sha256sums=('SKIP'
            '3bac812c74bfd71e7ee6536da5a369d31095d13de957a57a4702c3b3f2776744'
            '45dbb037c3fff5ff511767d154be58b17d5c9319755c1fae88464d6c9c31b047'
            )

pkgver() {
  cd $_pkgname
  git describe --tags --long | sed 's/-/./g'
}

prepare() {
  cd $_pkgname
  # to use a custom config.h, place it in the package directory
  for file in "${source[@]}"; do
      if [[ "$file" == "config.h" ]]; then
          # add config.h if present in source array
          # Note: this supersedes the above sed to config.def.h
          cp "$srcdir/$file" .
      elif [[ "$file" == *.diff || "$file" == *.patch ]]; then
          # add all patches present in source array
          patch -Np1 <"$srcdir/$(basename "${file}")"
      fi
  done
}

build(){
  cd $_pkgname
  make \
    X11INC=/usr/include/X11 \
    X11LIB=/usr/lib/X11
}

package() {
  cd $_pkgname
  make PREFIX=/usr DESTDIR="$pkgdir" install
  install -Dm644 LICENSE "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
}
