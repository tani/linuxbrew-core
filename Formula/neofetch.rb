class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/7.0.0.tar.gz"
  sha256 "8c6bd217cf6d34fc1f3dcbb0e8b1137655bc13fbb21165273dbb2a7bce0d3130"
  license "MIT"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfb4c9f42eee7659b0028a7d4de28524d5a6eb8f1199f83789fa0242b37c456e" => :catalina
    sha256 "bfb4c9f42eee7659b0028a7d4de28524d5a6eb8f1199f83789fa0242b37c456e" => :mojave
    sha256 "bfb4c9f42eee7659b0028a7d4de28524d5a6eb8f1199f83789fa0242b37c456e" => :high_sierra
    sha256 "ad35edefef328dd31f22f2afb7b3aa0758a8e3444978a0fbed5e268d919b8e6d" => :x86_64_linux
  end

  if OS.mac?
    depends_on "imagemagick"
    depends_on "screenresolution"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end
