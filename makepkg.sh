#!/bin/bash

# Maintainer: Ukang'a Dickson <ukanga@gmail.com>

_pkgname=dmenu
pkgname=$_pkgname-git
pkgver=4.9.5.gdb6093f
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
  sudo make PREFIX=/usr DESTDIR="$pkgdir" install
  sudo install -Dm644 LICENSE "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
}

prepare_sources() {
  # pkgdir=("$(pwd)/pkg")
  srcdir=("$(pwd)/src")
  rm -rf "${srcdir}" && mkdir -p "${srcdir}" && cd "${srcdir}"
  for file in "${source[@]}"; do
    if [[ "$file" == *.diff || "$file" == *.patch || "$file" == *.h ]]; then
      cp "$(dirname $(pwd))/$file" .
    fi
  done
  if [[ "$?" == 0 ]]; then
    git clone "${source}"
  else
    exit 1
  fi
}

prepare_sources
if [[ "$?" == 0 ]]; then
  prepare || exit 1
fi
if [[ "$?" == 0 ]]; then
  build || exit 1
fi
if [[ "$?" == 0 ]]; then
  package || exit 1
fi
if [[ "$?" == 0 ]]; then
  echo "Success"
else
  echo "Something went wrong!"  && exit 1
fi

# vim:set ts=2 sw=2 et:
