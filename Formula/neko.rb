class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/v2-3-0/neko-2.3.0.tar.gz"
  sha256 "850e7e317bdaf24ed652efeff89c1cb21380ca19f20e68a296c84f6bad4ee995"
  revision 2
  head "https://github.com/HaxeFoundation/neko.git"

  bottle do
    cellar :any
    sha256 "a2c2e95b27fbe6a15ce0efc03a40655e2a283e3be08acdb0cc398a9367ec76a2" => :catalina
    sha256 "bb0f7ece136bfa89ac5d690f936f3ba0b34bd8e3a256f73260297e2a5f8e67eb" => :mojave
    sha256 "7697cb00ffbca3583c0633d042959beda280c6a5e9c3b802d0c14883a1cead88" => :high_sierra
    sha256 "ab1fe2e7b70d180c7f306a993fd955db62ec19f55f1f7e3535d53f2639e4640b" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "mbedtls"
  depends_on "openssl@1.1"
  depends_on "pcre"
  unless OS.mac?
    depends_on "apr"
    depends_on "apr-util"
    depends_on "httpd"
    # On mac, neko uses carbon. On Linux it uses gtk2
    depends_on "gtk+"
    depends_on "pango"
    depends_on "sqlite"
  end

  def install
    args = std_cmake_args
    unless OS.mac?
      args << "-DAPR_LIBRARY=#{Formula["apr"].libexec}/lib"
      args << "-DAPR_INCLUDE_DIR=#{Formula["apr"].libexec}/include/apr-1"
      args << "-DAPRUTIL_LIBRARY=#{Formula["apr-util"].libexec}/lib"
      args << "-DAPRUTIL_INCLUDE_DIR=#{Formula["apr-util"].libexec}/include/apr-1"
    end
    inreplace "libs/mysql/CMakeLists.txt",
              %r{https://downloads.mariadb.org/f/},
              "https://downloads.mariadb.com/Connectors/c/"

    # Let cmake download its own copy of MariaDBConnector during build and statically link it.
    # It is because there is no easy way to define we just need any one of mariadb, mariadb-connector-c,
    # mysql, and mysql-client.
    system "cmake", ".", "-G", "Ninja", "-DSTATIC_DEPS=MariaDBConnector",
           "-DRELOCATABLE=OFF", "-DRUN_LDCONFIG=OFF", *args
    system "ninja", "install"
  end

  def caveats
    s = ""
    if HOMEBREW_PREFIX.to_s != "/usr/local"
      s << <<~EOS
        You must add the following line to your .bashrc or equivalent:
          export NEKOPATH="#{HOMEBREW_PREFIX}/lib/neko"
      EOS
    end
    s
  end

  test do
    ENV["NEKOPATH"] = "#{HOMEBREW_PREFIX}/lib/neko"
    system "#{bin}/neko", "-version"
    (testpath/"hello.neko").write '$print("Hello world!\n");'
    system "#{bin}/nekoc", "hello.neko"
    assert_equal "Hello world!\n", shell_output("#{bin}/neko hello")
  end
end
