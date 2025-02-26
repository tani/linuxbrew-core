class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/3.0/libsigc++-3.0.3.tar.xz"
  sha256 "e4f4866a894bdbe053e4fb22ccc6bc4b6851fd31a4746fdd20b2cf6e87c6edb6"
  license "LGPL-3.0"

  bottle do
    cellar :any
    sha256 "77bf9858cb60a1842d970bbbc020a5379536806acbc4114afa56d8c941013765" => :catalina
    sha256 "7ae9cb9a4d6a645574c6cf5aba8a9cfbbab44349545374f604073393c67f6f50" => :mojave
    sha256 "e2c75abf2675c7830fd19aa268472aeee8b5c42cd9355147585bad9be7c3059a" => :high_sierra
    sha256 "ac0c799922daffa86ca5b5c3ca069764a9c1d36199bc96d0c9f2f0055eb9cd86" => :x86_64_linux
  end

  depends_on :macos => :high_sierra if OS.mac? # needs C++17
  unless OS.mac?
    depends_on "m4" => :build
    depends_on "gcc@7"

    fails_with :gcc => "4"
    fails_with :gcc => "5"
    fails_with :gcc => "6"
  end

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end
  test do
    ENV["CXX"] = Formula["gcc@7"].opt_bin/"c++-7" unless OS.mac?
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <sigc++/sigc++.h>

      void on_print(const std::string& str) {
        std::cout << str;
      }

      int main(int argc, char *argv[]) {
        sigc::signal<void(const std::string&)> signal_print;

        signal_print.connect(sigc::ptr_fun(&on_print));

        signal_print.emit("hello world\\n");
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp",
                   "-L#{lib}", "-lsigc-3.0", "-I#{include}/sigc++-3.0", "-I#{lib}/sigc++-3.0/include", "-o", "test"
    assert_match "hello world", shell_output("./test")
  end
end
