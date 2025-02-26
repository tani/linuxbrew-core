class B2sum < Formula
  desc "BLAKE2 b2sum reference binary"
  homepage "https://github.com/BLAKE2/BLAKE2"
  url "https://github.com/BLAKE2/BLAKE2/archive/20190724.tar.gz"
  sha256 "7f2c72859d462d604ab3c9b568c03e97b50a4052092205ad18733d254070ddc2"

  bottle do
    cellar :any_skip_relocation
    sha256 "339b959eb5c2cbc8c26a39022937ea27b7911ff1c9f0611c3f2ac1595f5b0e50" => :catalina
    sha256 "905b975371fd88632649e08f732ff25277cd1fd4b584dbc3e4914bcb08f85cd8" => :mojave
    sha256 "129dbe4d91bf7843a40399b392b3ddc2448e56c249a45567bd9193e4fb722b37" => :high_sierra
    sha256 "772728967c21dbd98cb2afac3042a3ddacc88afd88e75de2e91d35ae90271bcb" => :x86_64_linux
  end

  conflicts_with "coreutils", :because => "both install `b2sum` binaries"

  def install
    cd "b2sum" do
      system "make", "NO_OPENMP=1"
      system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
    end
  end

  test do
    checksum = <<~EOS
      ba80a53f981c4d0d6a2797b69f12f6e94c212f14685ac4b74b12bb6fdbffa2d17d87c5392
      aab792dc252d5de4533cc9518d38aa8dbf1925ab92386edd4009923  -
    EOS
    assert_equal checksum.delete!("\n"),
                 pipe_output("#{bin}/b2sum -", "abc").chomp
  end
end
