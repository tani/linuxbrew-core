class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  revision 1

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.44.1-src.tar.gz"
    sha256 "7e2e64cb298dd5d5aea52eafe943ba0458fa82f2987fdcda1ff6f537b6f88473"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          :tag      => "0.45.0",
          :revision => "05d080faa4f2bc1e389ea7c4fd8f30ed2b733a7f"
    end
  end

  bottle do
    rebuild 1
    sha256 "5128f7d93695a04ba887284a8d6061202031524251053371b406f94d29738758" => :catalina
    sha256 "4679c3c77c502d67097ec602860dae400c64ea90e6064a45cd4444f27971eabb" => :mojave
    sha256 "0a2c02fe10827d361d888532adf4471de7df37edd509bd59c710358cb4e32494" => :high_sierra
    sha256 "2241c56362b10230a7734ad61dfa2d4f7014650e19f4a1425d09bd01533a6324" => :x86_64_linux
  end

  head do
    url "https://github.com/rust-lang/rust.git"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build
  depends_on "libssh2"
  depends_on "openssl@1.1"
  depends_on "pkg-config"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "binutils"
  end

  resource "cargobootstrap" do
    if OS.mac?
      # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2020-05-07/cargo-0.44.0-x86_64-apple-darwin.tar.gz"
      sha256 "1071c520204a9e8fe4dd0de66a07a083f06abba16ac88f1df72231328a6395e6"
    end
    unless OS.mac?
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2020-05-07/cargo-0.44.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e4c8533670a64a85ee1a367e4bb9d63a2d6b3e9949e116ec956cec15df9a67bd"
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"

    # Fix build failure for compiler_builtins "error: invalid deployment target
    # for -stdlib=libc++ (requires OS X 10.7 or later)"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if OS.mac?

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    # Fix build failure for cmake v0.1.24 "error: internal compiler error:
    # src/librustc/ty/subst.rs:127: impossible case reached" on 10.11, and for
    # libgit2-sys-0.6.12 "fatal error: 'os/availability.h' file not found
    # #include <os/availability.h>" on 10.11 and "SecTrust.h:170:67: error:
    # expected ';' after top level declarator" among other errors on 10.12
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    args = ["--prefix=#{prefix}"]
    if build.head?
      args << "--disable-rpath"
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end
    system "./configure", *args
    system "make"
    system "make", "install"

    resource("cargobootstrap").stage do
      system "./install.sh", "--prefix=#{buildpath}/cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath/"cargobootstrap/bin"

    resource("cargo").stage do
      ENV["RUSTC"] = bin/"rustc"
      args = %W[--root #{prefix} --path . --features curl-sys/force-system-lib-on-osx]
      args -= %w[--features curl-sys/force-system-lib-on-osx] unless OS.mac?
      system "cargo", "install", *args
      man1.install Dir["src/etc/man/*.1"]
      bash_completion.install "src/etc/cargo.bashcomp.sh"
      zsh_completion.install "src/etc/_cargo"
    end

    rm_rf prefix/"lib/rustlib/uninstall.sh"
    rm_rf prefix/"lib/rustlib/install.log"
  end

  def post_install
    Dir["#{lib}/rustlib/**/*.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      chmod 0444, dylib
    end
  end

  test do
    system "#{bin}/rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system "#{bin}/rustc", "hello.rs"
    assert_equal "Hello World!\n", `./hello`
    system "#{bin}/cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!",
                 (testpath/"hello_world").cd { `#{bin}/cargo run`.split("\n").last }
  end
end
