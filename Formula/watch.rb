class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps.git",
      :tag      => "v3.3.16",
      :revision => "59c88e18f29000ceaf7e5f98181b07be443cf12f"
  license "GPL-2.0"
  head "https://gitlab.com/procps-ng/procps.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "011e48363fe62c7a4ba0dec746d5964ee25545bde7855a31db0cb411420df190" => :catalina
    sha256 "d17aba6f80c530e6b91b30e088df60aab3dc84b2f57ca7499928322438b9f0d2" => :mojave
    sha256 "13d63ebc419965182d98f10b25cc99961679e1ba5ce6118e66b7037eb4e78de8" => :high_sierra
    sha256 "5e354a0971729694c7d641fcde59ae6f63788e004b1557a13dd5db8f204788de" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "ncurses"

  conflicts_with "visionmedia-watch"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-nls",
                          "--enable-watch8bit"
    system "make", "watch"
    bin.install "watch"
    man1.install "watch.1"
  end

  test do
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
