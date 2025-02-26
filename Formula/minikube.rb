class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      :tag      => "v1.12.0",
      :revision => "c83e6c47124b71190e138dbc687d2556d31488d6"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfa00eb2a001481ecd9439978bc8b7b4bbfa88a5ccc2cdd0f09a3892eae399c9" => :catalina
    sha256 "ff46c53ba1713f56ffe1c08f779f081e909251d4654baa5cc8c8a147cc60a07c" => :mojave
    sha256 "6d80ac39b1f914c1b80af637fb839c6767bbe15636ec62df7657bbdd0b797f2e" => :high_sierra
    sha256 "29466753ca48db7aae31e8fc9f7e6fec8b265c009c4fef97e4d3ee5b1c0b7b6b" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "bash")
    (bash_completion/"minikube").write output

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "zsh")
    (zsh_completion/"_minikube").write output
  end

  test do
    output = shell_output("#{bin}/minikube version")
    assert_match "version: v#{version}", output

    (testpath/".minikube/config/config.json").write <<~EOS
      {
        "vm-driver": "virtualbox"
      }
    EOS
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end
