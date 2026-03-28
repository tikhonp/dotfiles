#! /usr/bin/env sh

# useful if post-install `pacman` hooks were previously interrupted

set -eu

DEPS=$(pacman -Q --deps --native --quiet)
if [ -n "${DEPS}" ]; then
  echo "${DEPS}" | sudo pacman -S --asdeps -
fi

EXPLICITS=$(pacman -Q --explicit --native --quiet)
if [ -n "${EXPLICITS}" ]; then
  echo "${EXPLICITS}" | sudo pacman -S --asexplicit -
fi
