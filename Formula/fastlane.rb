class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.152.0.tar.gz"
  sha256 "cf35921559f924bfee538eb14bbd04811e54e07b692042a3699dede76e1e57db"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "133fd49959694621a60d6212e9e21631c34015b836427353e8c864a280d579cb" => :catalina
    sha256 "346c5892ebc93be7f37ab7e080db591d4d91c1849096b478739a1873988af4f9" => :mojave
    sha256 "6d96e2a20decfae69a34e7e774edaa30da4b3d7f7895291612c33031a6d27d53" => :high_sierra
    sha256 "d9f62c13bb152a49a2f906f55dda5b1934bce3b34773df2d72c651e67f86a87a" => :x86_64_linux
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby"].opt_bin}:#{libexec}/bin:$PATH"
      GEM_HOME="#{libexec}" GEM_PATH="#{libexec}" \\
        exec "#{libexec}/bin/fastlane" "$@"
    EOS
    chmod "+x", bin/"fastlane"
  end

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end
