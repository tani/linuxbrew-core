class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v0.6.3.tar.gz"
  sha256 "11f26f97db4bde558266b4762c47e8c83ce2da5739fc45d6d164b5e69b74ed9e"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "76d21ca8ed7484c4fbaf81761c0ba097d7ce260ddaa8e7cfaf9656ee490c4a3e" => :catalina
    sha256 "687ca1b46a3847b5d1aff0f744d3a6cf5aa0fe783620d0f4bb41f9f0e8e17af6" => :mojave
    sha256 "b04d75c514fa8e6b8ba9fd631a538d687650bf46e63e47d6a7a3af3db5415901" => :high_sierra
    sha256 "05fe8c5b105483b1722a498f4f896dfc462d4d8b746bb1a08c7bc7c121780ef1" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system "./build_completions.sh"
    bash_completion.install "utils/completions/pueue.bash" => "pueue"
    fish_completion.install "utils/completions/pueue.fish" => "pueue.fish"

    prefix.install_metafiles
  end

  plist_options :manual => "pueued"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/pueued</string>
            <string>--verbose</string>
          </array>
          <key>KeepAlive</key>
          <false/>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/pueued.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/pueued.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    mkdir OS.mac? ? testpath/"Library/Preferences" : testpath/".config"

    begin
      pid = fork do
        exec bin/"pueued"
      end
      sleep 5
      cmd = "#{bin}/pueue status"
      assert_match /Task list is empty.*/m, shell_output(cmd)
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "Pueue daemon #{version}", shell_output("#{bin}/pueued --version")
    assert_match "Pueue client #{version}", shell_output("#{bin}/pueue --version")
  end
end
