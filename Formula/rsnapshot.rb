class Rsnapshot < Formula
  desc "File system snapshot utility (based on rsync)"
  homepage "https://www.rsnapshot.org/"
  url "https://github.com/rsnapshot/rsnapshot/releases/download/1.4.3/rsnapshot-1.4.3.tar.gz"
  sha256 "2b0c7aad3e14e0260513331425a605d73c3bdd7936d66d418d7714a76bc55bd1"
  license "GPL-2.0"
  head "https://github.com/rsnapshot/rsnapshot.git"

  depends_on "rsync" unless OS.mac?

  bottle do
    cellar :any_skip_relocation
    sha256 "e195b17e2c28a787e6bc183c3f57397256fba91c8d5c490f3c24576033d39a74" => :catalina
    sha256 "e195b17e2c28a787e6bc183c3f57397256fba91c8d5c490f3c24576033d39a74" => :mojave
    sha256 "e195b17e2c28a787e6bc183c3f57397256fba91c8d5c490f3c24576033d39a74" => :high_sierra
    sha256 "6f1afd70686726147492a9952d496e74c50d7016c5f6f962e446bb248b748663" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/rsnapshot", "--version"
  end
end
