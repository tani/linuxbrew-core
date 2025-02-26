class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      :tag      => "0.35.1",
      :revision => "579475721b14487e225e57a64ecd44781d244b33"
  license "BSD-2-Clause"

  bottle do
    sha256 "398704cb374f8197b391d1abe79f6937b47907ac79bff429c3c7c5436b7baf82" => :catalina
    sha256 "32a740aba344f2f864dab4e95ed811ec5274a5dc0f72760bc0dc916b749d0b48" => :mojave
    sha256 "4bff26ba76aef06e7d0f5aee757729d7494b8c98605fc06f994ea4de0b2f99f2" => :high_sierra
    sha256 "dd4feaed5bd87116d85f54c8fabb234180ed01ec30acbe72d7f26dd174e0d0d2" => :x86_64_linux
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    unless OS.mac?
      inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"/usr/bin/gcc\""
    end

    ENV["MAKEFLAGS"] = "build_flags=-j#{ENV.make_jobs}"
    system "make", "libs"
    system "make", "configure"
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
