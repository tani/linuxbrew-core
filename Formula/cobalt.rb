class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.15.11.tar.gz"
  sha256 "f938b1dba3fe1874f87d9ced31ff6a8ba62c27927247fef6ba6c41897a30a62a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7c8244a8382566add8c7079660767c3c1a5fe9d7ab86c345cef6b1117d2b800" => :catalina
    sha256 "ea5ecf4c34c78804e3cfa3ea54ca7af15872ea3929ba8a397f108430fdf8296e" => :mojave
    sha256 "e67e4a6d4176e16ba9e089325204d7c3bde339141067b4df13b4f0bfe6019e0a" => :high_sierra
    sha256 "b22e05f2d27d97beaaee8ec55cacf01b93f0da22e35645f2729360c5b6ada50d" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
