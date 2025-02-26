class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https://github.com/10gen/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/72/34/9f010c4ac8569314569ea69a93a234d1dedf211666ab0b01b919d7843dba/mongo-orchestration-0.6.12.tar.gz"
  sha256 "d73f7666424ee6e4b2143c1e2f72025b15236dacd07c80a374a44bb056d53a6b"
  license "Apache-2.0"
  head "https://github.com/10gen/mongo-orchestration.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33576a232a292049ed59ff028ce32bfd14e770742d2156cc04ee26cf20cb45ff" => :catalina
    sha256 "cb16ab4631efca5cb55fa62e45b84d274169d432964ecef16c34e49380a636f7" => :mojave
    sha256 "0f068f4639a7e4f7686bf5b6a80bd08b32e2ef4514dcecb4fbfb3dcd86c379be" => :high_sierra
    sha256 "59826908c01cb8dd8976953f49f691110adffb673b025f495b9875fb2cc3cd36" => :x86_64_linux
  end

  depends_on "python@3.8"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/d9/4f/57887a07944140dae0d039d8bc270c249fc7fc4a00744effd73ae2cde0a9/bottle-0.12.18.tar.gz"
    sha256 "0819b74b145a7def225c0e83b16a4d5711fde751cd92bae467a69efce720f69e"
  end

  resource "CherryPy" do
    url "https://files.pythonhosted.org/packages/50/c6/6c3d7a3221b0f098f8684037736e5604ea1586a3ba450c4a52b48f5fc2b4/CherryPy-7.0.0.tar.gz"
    sha256 "faead7c5c7ca2526aff8f179a24d699127ed307c3393eeef9610a33b93650bef"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/a8/f6/f324f5c669478644ac64594b9d746a34e185d9c34d3f05a4a6a6dab5467b/pymongo-3.5.1.tar.gz"
    sha256 "e820d93414f3bec1fa456c84afbd4af1b43ff41366321619db74e6bc065d6924"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  plist_options :startup => true, :manual => "#{HOMEBREW_PREFIX}/opt/mongo-orchestration/bin/mongo-orchestration -b 127.0.0.1 -p 8889 --no-fork start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>mongo-orchestration</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/mongo-orchestration</string>
            <string>-b</string>
            <string>127.0.0.1</string>
            <string>-p</string>
            <string>8889</string>
            <string>--no-fork</string>
            <string>start</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/mongo-orchestration", "-h"
  end
end
