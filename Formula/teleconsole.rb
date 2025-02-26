require "language/go"

class Teleconsole < Formula
  desc "Free service to share your terminal session with people you trust"
  homepage "https://www.teleconsole.com"
  url "https://github.com/gravitational/teleconsole/archive/0.4.0.tar.gz"
  sha256 "ba0a231c5501995e2b948c387360eb84e3a44fe2af6540b6439fc58637b0efa4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd114a850d3e9eb653e6ed08f53224bd81219c7bcfbd2459440b68a0e96711dc" => :catalina
    sha256 "4a5a767d1097e9e8580e3d3ad77d01b8b840ef622092983d713333ed90d2db0d" => :mojave
    sha256 "d53e81606f1e85b59bd3ee364e006989187f5cce884b33fb77b104b931a7e3c5" => :high_sierra
    sha256 "c74fa8ac5e92c39a3f0d869b9e8bd44d32ab67ed0748b5548a0700287dfbe817" => :sierra
    sha256 "755c2ad0d13fbb7f1c492fc726d0656b92d58a8195ff24b37ad809d4911cdeb2" => :x86_64_linux
  end

  depends_on "go" => :build

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
        :revision => "d26492970760ca5d33129d2d799e34be5c4782eb"
  end

  go_resource "github.com/gravitational/trace" do
    url "https://github.com/gravitational/trace.git",
        :revision => "6e153c7add15eb07e311f892779fb294373c4cfa"
  end

  go_resource "github.com/gravitational/teleport" do
    url "https://github.com/gravitational/teleport.git",
        :revision => "2cb40abd8ea8fb2915304ea4888b5b9f3e5bc223"
  end

  go_resource "github.com/jonboulle/clockwork" do
    url "https://github.com/jonboulle/clockwork.git",
        :revision => "bcac9884e7502bb2b474c0339d889cb981a2f27f"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "9477e0b78b9ac3d0b03822fd95422e2fe07627cd"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "55a3084c9119aeb9ba2437d595b0a7e9cb635da9"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "bf82308e8c8546dc2b945157173eb8a959ae9505"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "d228849504861217f796da67fae4f6e347643f15"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "66b8e73f3f5cda9f96b69efd03dd3d7fc4a5cdb8"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/gravitational"
    ln_s buildpath, buildpath/"src/github.com/gravitational/teleconsole"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"teleconsole"
  end

  test do
    system "#{bin}/teleconsole", "help"
  end
end
