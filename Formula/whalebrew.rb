class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew.git",
    :tag      => "0.2.3",
    :revision => "7b371f6e0fa414e61761359441268b61c8a741ff"
  license "Apache-2.0"
  head "https://github.com/whalebrew/whalebrew.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3243317cffe305c9c21a458793f4319b9784e979cf3225663df3e83b53e1736f" => :catalina
    sha256 "9abfd2e5951f589dde2cc9847b44e77741785a8b9ff5208c958bd8233def74b8" => :mojave
    sha256 "66e059ff26ef8e1a7d15416bf0b3a946716e03e60cf7f1281e572dcd78b1f4d8" => :high_sierra
    sha256 "a6357b16b2285d65c523902fa90180f3b6e77b08196cf6edce3f32b38202ff54" => :sierra
    sha256 "2c9aded52aa7f5457948df8bf5dd6f713e5950d13965e05b35df0a560a42acb8" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"whalebrew", "."
  end

  test do
    output = shell_output("#{bin}/whalebrew install whalebrew/whalesay -y", 255)
    if File.exist?("/var/run/docker.sock") && ENV["CI"]
      assert_match "Unable to find image", output
    else
      assert_match "Cannot connect to the Docker daemon", output
    end
  end
end
