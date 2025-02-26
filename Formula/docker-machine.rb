class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine.git",
      :tag      => "v0.16.2",
      :revision => "bd45ab13d88c32a3dd701485983354514abc41fa"
  license "Apache-2.0"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99b50d9809a0aa881e01686e3356fbd17fa61e5a5e8cb937a2a9e9ff103be097" => :catalina
    sha256 "cc56a9c37702ecaeea1a5034326d87fa145fbc4cb613d151756571b78ca8f1ab" => :mojave
    sha256 "320ef0f8b7fba8e679c784f854155314c7bdcbc4e7d43fd11dbce6e0e3e0f85b" => :high_sierra
    sha256 "23a2165e741ea1a9321476d3037a5d76bc24bd494ae0bd8b16f35e3248c0aa77" => :sierra
    sha256 "5f2e8a19e50bd86e950f26a996cb2d84e1ea731045885ae725a70acb6e52635c" => :x86_64_linux
  end

  depends_on "automake" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/docker/machine").install buildpath.children
    cd "src/github.com/docker/machine" do
      system "make", "build"
      bin.install Dir["bin/*"]
      bash_completion.install Dir["contrib/completion/bash/*.bash"]
      zsh_completion.install "contrib/completion/zsh/_docker-machine"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "docker-machine start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>EnvironmentVariables</key>
          <dict>
              <key>PATH</key>
              <string>/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin</string>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_bin}/docker-machine</string>
              <string>start</string>
              <string>default</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output(bin/"docker-machine --version")
  end
end
