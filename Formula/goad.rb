class Goad < Formula
  desc "AWS Lambda powered, highly distributed, load testing tool built in Go"
  homepage "https://goad.io/"
  url "https://github.com/goadapp/goad.git",
      :tag      => "2.0.4",
      :revision => "e015a55faa940cde2bc7b38af65709d52235eaca"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "57345918587236f5235fcacc3d6d7f64272a5c1def4e64632fee13b960c027b5" => :catalina
    sha256 "366aad32eaa55e8561244bc31dc7650d829dd1f588801ad5d986a22cbfc80418" => :mojave
    sha256 "3a87755d9b4b48b07a7fecd9be72df574d5866fe39d4dc0c60d6a88da40c5081" => :high_sierra
    sha256 "b10fb1177f1f3548b2a497cb56ce9f10620a06175adec6a1d452b0e136981d1e" => :sierra
    sha256 "f0c6400909fbe194400717025ad64cba2ccd63b1db9cba5ec7a9195274614b41" => :el_capitan
    sha256 "9678004ba4e2fb543e7fd9ce570948130810fc4ad7315fbb443531b2f57afd81" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "zip" => :build unless OS.mac?

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/goadapp/goad"
    dir.install buildpath.children

    cd dir do
      system "make", "build"
      bin.install "build/goad"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/goad", "--version"
  end
end
