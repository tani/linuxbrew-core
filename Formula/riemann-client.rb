class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-1.10.4.tar.gz"
  sha256 "334874f0b9a507a8abbc7138df719cba4f28f12c02c39d5e55090b8edb86f9d2"
  revision 1
  head "https://github.com/algernon/riemann-c-client.git"

  bottle do
    cellar :any
    sha256 "3227f7774fb1ff0e7daeb4b8c75c0e976a928593b85a8ef2726542ef3bab634b" => :catalina
    sha256 "1a11eb37bbb1021c3aee0e2e5173dba58fb48172418cf632e76811f08483a39d" => :mojave
    sha256 "245fe4d845c711bc9d1b99f0697d1cb98811633a608c62f415a4e2c0f05ebd1a" => :high_sierra
    sha256 "40f04bf7269b9de06c801f6ed576939c0d4364f8ba69b5a0fb385033596c64be" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "json-c"
  depends_on "protobuf-c"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/riemann-client", "send", "-h"
  end
end
