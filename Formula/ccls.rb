class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20190823.6.tar.gz"
  sha256 "83dd45120e9674319f91e4379013831e124c0858e050bbc3521e3f8aebe5c95b"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256 "826b74e4e2f5ed44734b1776e960fb4485bbd20ee6383dc9bc426ca2fed9ba03" => :catalina
    sha256 "f32c94ebdd1b65fa75a32701573dfb1c87d16a339f57f261712ead133caeab3f" => :mojave
    sha256 "fe0edff63df20a3c4624ce335c73276299f60d5bfad836c1acba32ce7435de18" => :high_sierra
    sha256 "342494b296a491c055769bdcfdaac545951c867897ec7cd418368090cd37216b" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on :macos => :high_sierra # C++ 17 is required
  depends_on "gcc@9" unless OS.mac? # C++17 is required

  fails_with :gcc => "4"
  fails_with :gcc => "5"
  fails_with :gcc => "6"
  fails_with :gcc => "7" do
    version "7.1"
  end

  def install
    # https://github.com/Homebrew/brew/issues/6070
    ENV.remove %w[LDFLAGS LIBRARY_PATH HOMEBREW_LIBRARY_PATHS], "#{HOMEBREW_PREFIX}/lib" unless OS.mac?

    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"ccls", "-index=#{testpath}"
  end
end
