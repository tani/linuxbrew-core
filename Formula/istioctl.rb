class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.6.5",
      :revision => "f508fdd78eb0d3444e2bc2b3f36966d904c5db52"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "30f8f07445295591c134fd2e65a11e6023e60c8d924723b27abeaccf3d0a628f" => :catalina
    sha256 "30f8f07445295591c134fd2e65a11e6023e60c8d924723b27abeaccf3d0a628f" => :mojave
    sha256 "30f8f07445295591c134fd2e65a11e6023e60c8d924723b27abeaccf3d0a628f" => :high_sierra
    sha256 "360ff1ff49bb0748da29d6f14105854748aad22f2de100419686192b188d1ee3" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = OS.mac? ? srcpath/"out/darwin_amd64" : srcpath/"out/linux_amd64"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "gen-charts", "istioctl", "istioctl.completion"
      prefix.install_metafiles
      bin.install outpath/"istioctl"
      bash_completion.install outpath/"release/istioctl.bash"
      zsh_completion.install outpath/"release/_istioctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
