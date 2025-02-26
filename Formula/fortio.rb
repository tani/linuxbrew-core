class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      :tag      => "v1.4.4",
      :revision => "5840a17ec92d01f2969f354cabf9615339eb8286"
  license "Apache-2.0"

  bottle do
    sha256 "eb7ad27d0985ad822d615b43bf5aa11793973484907c1b2936f2d36b60a4eb9a" => :catalina
    sha256 "749448105b97a48b1843f0bb425673832421dbb0c8d8d67705e6b96fe844ba3f" => :mojave
    sha256 "af1a3261b9773c7744db0bcb2add09e2fffe515ece1fc441f04e1ce0a4a7be60" => :high_sierra
    sha256 "f46f6dcced35813be668e40d9f7b0aad8d50433acea05c8feb38eb0e3c540446" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "make", "official-build", "OFFICIAL_BIN=#{bin}/fortio", "LIB_DIR=#{lib}"
    lib.install "ui/static", "ui/templates"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")

    port = free_port
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match /^All\sdone/, output.lines.last
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
