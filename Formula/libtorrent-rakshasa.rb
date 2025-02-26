class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/v0.13.8.tar.gz"
  sha256 "0f6c2e7ffd3a1723ab47fdac785ec40f85c0a5b5a42c1d002272205b988be722"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "207e33009028a8721a89c91139fe78fea1cd9fb8a05862286264dfc53548886a" => :catalina
    sha256 "94afd9fcef673d4e3945c13085df931e12c1bf2422bf6a2ad2c6848634c2fa65" => :mojave
    sha256 "135df02ce3bb98b05d9f849b8014087e8acaefcc24b1547ff9b1740bbd74492a" => :high_sierra
    sha256 "fd0289f02557000737c036cb0321fcf42a84effd36af56375989c968c2fc88cf" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  conflicts_with "libtorrent-rasterbar",
    :because => "they both use the same libname"

  def install
    args = ["--prefix=#{prefix}", "--disable-debug",
            "--disable-dependency-tracking"]

    system "sh", "autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <string>
      #include <torrent/torrent.h>
      int main(int argc, char* argv[])
      {
        return strcmp(torrent::version(), argv[1]);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    system "./test", version.to_s
  end
end
