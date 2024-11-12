#!/usr/bin/env sh

build() {
  zig build "-Dtarget=$1-linux-android" lib
  mkdir -p "android/lib/$1"
  cp zig-out/lib/libremote-input.so "android/lib/$1/"
}

build "aarch64"

