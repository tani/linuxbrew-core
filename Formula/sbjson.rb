class Sbjson < Formula
  desc "JSON CLI parser & reformatter based on SBJson v5"
  homepage "https://github.com/stig/json-framework"
  url "https://github.com/stig/json-framework/archive/v5.0.3.tar.gz"
  sha256 "9a03f6643b42a82300f4aefcfb6baf46cc2c519f1bb7db3028f338d6d1c56f1b"
  license "BSD-3-Clause"
  head "https://github.com/stig/json-framework.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e703b87ff205bfec1cfc09e9c200ebca6be643df15ec99b85c590110a4885fb2" => :catalina
    sha256 "8b145bcfef84733c00d94e57cbe0eac56a7981654cda6068ff219264353b25bd" => :mojave
    sha256 "649463e051c03596a72400a04b95f993222f5ba6d42a879241291660fef8605c" => :high_sierra
  end

  depends_on :xcode => :build if OS.mac?
  depends_on :macos

  def install
    xcodebuild "-project", "SBJson5.xcodeproj",
               "-target", "sbjson",
               "-configuration", "Release",
               "clean",
               "build",
               "SYMROOT=build"

    bin.install "build/Release/sbjson"
  end

  test do
    (testpath/"in.json").write <<~EOS
      [true,false,"string",42.001e3,[],{}]
    EOS

    (testpath/"unwrapped.json").write <<~EOS
      true
      false
      "string"
      42001
      []
      {}
    EOS

    assert_equal shell_output("cat unwrapped.json"),
                 shell_output("#{bin}/sbjson --unwrap-root in.json")
  end
end
