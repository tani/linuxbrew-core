class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul.git",
      :tag      => "v1.8.0",
      :revision => "3111cb8c7df8545abaa0c96347996b5341ff625d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git",
       :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "62f051244bfe72f748a7ced54bffae31d3a42e1e9116750f4b01d26008012e18" => :catalina
    sha256 "a4f980e5674099da1126571ade778cf935e80d1325c71104194bd40de7bbcac8" => :mojave
    sha256 "d0e30c7d24b99ba1dba65f4ff57019995ff44905ada6c6f5068ae5af0faf0694" => :high_sierra
    sha256 "090a5606a46d0d7abfa7c07db0a393860698ca0998c989199840df6c8fe58cd1" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  uses_from_macos "zip" => :build

  def install
    ENV["XC_OS"] = OS.mac? ? "darwin" : "linux"
    ENV["XC_ARCH"] = "amd64"
    ENV["GOPATH"] = buildpath
    contents = Dir["{*,.git,.gitignore}"]
    (buildpath/"src/github.com/hashicorp/consul").install contents

    (buildpath/"bin").mkpath

    cd "src/github.com/hashicorp/consul" do
      system "make"
      bin.install "bin/consul"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "consul agent -dev -bind 127.0.0.1"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/consul</string>
            <string>agent</string>
            <string>-dev</string>
            <string>-bind</string>
            <string>127.0.0.1</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/consul.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/consul.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    http_port = free_port
    fork do
      # most ports must be free, but are irrelevant to this test
      system(
        "#{bin}/consul",
        "agent",
        "-dev",
        "-bind", "127.0.0.1",
        "-dns-port", "-1",
        "-grpc-port", "-1",
        "-http-port", http_port,
        "-serf-lan-port", free_port,
        "-serf-wan-port", free_port,
        "-server-port", free_port
      )
    end

    # wait for startup
    sleep 3

    k = "brew-formula-test"
    v = "value"
    system "#{bin}/consul", "kv", "put", "-http-addr", "127.0.0.1:#{http_port}", k, v
    assert_equal v, shell_output("#{bin}/consul kv get -http-addr 127.0.0.1:#{http_port} #{k}").chomp
  end
end
