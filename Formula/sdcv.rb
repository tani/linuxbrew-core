class Sdcv < Formula
  desc "StarDict Console Version"
  homepage "https://dushistov.github.io/sdcv/"
  url "https://github.com/Dushistov/sdcv/archive/v0.5.2.tar.gz"
  sha256 "ec08dc084a0748d5a89df01a20bbf294f09b0366295cd418000f15d2e043c4f7"
  license "GPL-2.0"
  revision 2
  version_scheme 1
  head "https://github.com/Dushistov/sdcv.git"

  bottle do
    sha256 "88e35b34c8965ea668da4aeb0e96e90c6e1c8a400e8c119936ebb5180c0afce3" => :catalina
    sha256 "d40dc4d63326ca5268f5b1d75a8a64ecc0081fe6e35d6279ee937774b39cfb33" => :mojave
    sha256 "322ec61f8ae7914f8a8f5da7fac01ef0ee69aa9f9844e1c876168f9fdf54887a" => :high_sierra
    sha256 "e0aa6779b49ae274e5a9da62a12caceaf2149b587d96ce051bd5c7d735c81fa4" => :sierra
    sha256 "77df7917057d9bc8304d417dc06d06eeb91cc8882b8a7dd04779c3fef7425b03" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "readline"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "lang"
      system "make", "install"
    end
  end

  test do
    system bin/"sdcv", "-h"
  end
end
