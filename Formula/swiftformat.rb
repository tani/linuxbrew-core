class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.17.tar.gz"
  sha256 "71cf14ae08415aabaa92349ee3accfc23077972c78f481819cb706092e2f4780"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "8ef7a5641318a9cadebed039c73d36c82d72a1236168d22848dbaccd0d578c39" => :catalina
    sha256 "c6c1eaad9cab4e82e63cca194c8449722709fc8262ae1e02e3b8926f67fcc685" => :mojave
    sha256 "3ad0bcd008b2d1efd28af92ab3bd76194880cb0c04c0f68a6f3ad77efcfc42b0" => :high_sierra
  end

  depends_on :xcode => ["10.1", :build] if OS.mac?
  depends_on :macos

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
