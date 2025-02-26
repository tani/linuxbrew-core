require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.18.0.tar.gz"
  sha256 "0ebe67e543226721c3802dd56db0355575accf50f10c09fe188bbb604aa8c193"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "63418b66810e1792249522adb0ec5a4b952e4bef34a5425525ca2d7eccbc69ee" => :catalina
    sha256 "519d3abecbff0d2cc2aaead01027d18e3b061c45dd63de429c4baab0c677b1ed" => :mojave
    sha256 "bc87517a3a30252c0477e4862146ac33604b355a8c900f566bfaa1f404a284ad" => :high_sierra
    sha256 "a868185b4115999f81aa072623e67a81b8bd08dfc0b42ed4f5e12eeaa39a11e8" => :x86_64_linux
  end

  depends_on "haskell-stack" => :build

  uses_from_macos "xz"

  on_linux do
    depends_on "gmp"
  end

  def install
    unless OS.mac?
      gmp = Formula["gmp"]
      ENV.prepend_path "LD_LIBRARY_PATH", gmp.lib
      ENV.prepend_path "LIBRARY_PATH", gmp.lib
    end

    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    system "stack", "-j#{jobs}", "build"
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
