class Cquery < Formula
  desc "C/C++ language server"
  homepage "https://github.com/cquery-project/cquery"
  # pull from git tag to get submodules
  url "https://github.com/cquery-project/cquery.git",
      :tag      => "v20180718",
      :revision => "b523aa928acf8ffb3de6b22c79db7366a9672489"
  license "MIT"
  head "https://github.com/cquery-project/cquery.git"
  revision 2 unless OS.mac?

  bottle do
    sha256 "8d2680e2397cbaa0a6c6cb2ffa00da5a10d3c2b89f5faeaa493c066417199e87" => :catalina
    sha256 "e35aabf6a4b2b0ac21c59b6e6121aa3bc8cc623ca7fe1bd763dd6430d3339eae" => :mojave
    sha256 "ee46fd2b279edc3b52df5ca9b84bdce404bb888f8a7d31e092b3fda33285a02b" => :high_sierra
    sha256 "ac3ad5aada30ca31d70f36e6e3ba76d96aa0e235ccdd62259a086578fe182b44" => :sierra
    sha256 "d40c1ad58cc6c437eb718cbd26204d101cc140c05784428ac5cc0f7d93661613" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  # error: 'shared_timed_mutex' is unavailable: introduced in macOS 10.12
  depends_on :macos => :sierra

  def install
    system "cmake", ".", "-DSYSTEM_CLANG=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"cquery", "--test-unit"
  end
end
