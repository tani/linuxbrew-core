class ErlangAT20 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-20.3.8.26.tar.gz"
  sha256 "dce78b60938a48b887317e5222cff946fd4af36666153ab2f0f022aa91755813"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "130019a8e459654a92e7267b60932867c8c27957d5bd5b791e358407e6d2755b" => :catalina
    sha256 "5e1003bf97321f4cf5cd57b062b752c2d92bcbb457ab5e992309790b7827fd1f" => :mojave
    sha256 "a401feb22927ecc0e649f3f2f7aeba331725b6390985f826ed5639d59732ee6a" => :high_sierra
    sha256 "97ecb6ce73d469360e859be66f428b9aacba41403fb8e3214bf6a031d694f96e" => :x86_64_linux
  end

  # Deprecated with OTP-23 release (https://erlang.org/pipermail/erlang-questions/2020-July/099747.html)
  deprecate! :date => "2020-05-13"

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

  uses_from_macos "m4" => :build

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_20.3.tar.gz"
    mirror "https://fossies.org/linux/misc/legacy/otp_doc_man_20.3.tar.gz"
    sha256 "17e0b2f94f11576a12526614a906ecad629b8804c25e6c18523f7c4346607112"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_20.3.tar.gz"
    mirror "https://fossies.org/linux/misc/legacy/otp_doc_html_20.3.tar.gz"
    sha256 "8099b62e9fa24b3f90eaeda151fa23ae729c8297e7d3fd8adaca865b35a3125d"
  end

  def install
    # Work around Xcode 11 clang bug
    # https://bitbucket.org/multicoreware/x265/issues/514/wrong-code-generated-on-macos-1015
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-sctp
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    (lib/"erlang").install resource("man").files("man")
    doc.install resource("html")
  end

  def caveats
    <<~EOS
      Man pages can be found in:
        #{opt_lib}/erlang/man

      Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
