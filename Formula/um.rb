class Um < Formula
  desc "Command-line utility for creating and maintaining personal man pages"
  homepage "https://github.com/sinclairtarget/um"
  url "https://github.com/sinclairtarget/um/archive/4.2.0.tar.gz"
  sha256 "f8c3f4bc5933cb4ab9643dcef7b01b8e8edf2dcbcd8062ef3ef214d1673ae64e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "266b397cd3e24060e7926f438279325aed89643070618add3db64175e348c04b" => :catalina
    sha256 "a4d8c9ddc2b46076eaccf3e3d4eaa43918f3d156e8abd16ad1415ea85f2da8f5" => :mojave
    sha256 "a479ed6f535f228d1bfa15a7292e58d06a4f07d1238c4fa83f1b99c80564a24e" => :high_sierra
    sha256 "965706a7846d6e06e1c21f592c477a597cd7ccf78d266a3ef5d3ab811fd1020b" => :x86_64_linux
  end

  depends_on "ruby" if !OS.mac? || MacOS.version <= :sierra

  resource "kramdown" do
    url "https://rubygems.org/gems/kramdown-1.17.0.gem"
    sha256 "5862410a2c1692fde2fcc86d78d2265777c22bd101f11c76442f1698ab242cd8"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "um.gemspec"
    system "gem", "install", "--ignore-dependencies", "um-#{version}.gem"

    bin.install libexec/"bin/um"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])

    bash_completion.install "um-completion.sh"
    man1.install Dir["doc/man1/*"]
  end

  test do
    system bin/"um", "topic", "-d" # Set default topic

    output = shell_output("#{bin}/um topic")
    assert_match shell_output("#{bin}/um config default_topic"), output
  end
end
