class OpenjdkAT11 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://hg.openjdk.java.net/jdk-updates/jdk11u/archive/jdk-11.0.7+10.tar.bz2"
  version "11.0.7+10"
  sha256 "e86d27cc3119be2178fc20c0115f8863fa86ac3ffd0c825fef7d16683f78b852"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "1cef37f5566ca7c60c03bad337c81516525459a7c4892519bc9badf90633a935" => :catalina
    sha256 "5bb229b65beda25d23ffee46f02bc8a921ad21c9312716e20ea4eba2cfb27901" => :mojave
    sha256 "2ee32dada456c7c8560ebda3d6b182a80a83b015cd91a30e82602ae0b5e4ce0a" => :high_sierra
    sha256 "2fb2601acfe01331d503df321c6ea237f18326595115238dc44c36a3f498aff4" => :x86_64_linux
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "cups"
    depends_on "fontconfig"
    depends_on "unzip"
    depends_on "zip"
    depends_on "linuxbrew/xorg/libx11"
    depends_on "linuxbrew/xorg/libxext"
    depends_on "linuxbrew/xorg/libxrandr"
    depends_on "linuxbrew/xorg/libxrender"
    depends_on "linuxbrew/xorg/libxt"
    depends_on "linuxbrew/xorg/libxtst"
  end

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "boot-jdk" do
    if OS.mac?
      url "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_osx-x64_bin.tar.gz"
      sha256 "77ea7675ee29b85aa7df138014790f91047bfdafbc997cb41a1030a0417356d7"
    else
      url "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz"
      sha256 "f3b26abc9990a0b8929781310e14a339a7542adfd6596afb842fa0dd7e3848b2"
    end
  end

  def install
    boot_jdk_dir = Pathname.pwd/"boot-jdk"
    resource("boot-jdk").stage boot_jdk_dir
    boot_jdk = OS.mac? ? boot_jdk_dir/"Contents/Home" : boot_jdk_dir
    java_options = ENV.delete("_JAVA_OPTIONS")

    short_version, _, build = version.to_s.rpartition("+")

    chmod 0755, "configure"
    system "./configure", "--without-version-pre",
                          "--without-version-opt",
                          "--with-version-build=#{build}",
                          "--with-toolchain-path=/usr/bin",
                          ("--with-extra-ldflags=-headerpad_max_install_names" if OS.mac?),
                          "--with-boot-jdk=#{boot_jdk}",
                          "--with-boot-jdk-jvmargs=#{java_options}",
                          "--with-debug-level=release",
                          "--with-native-debug-symbols=none",
                          "--enable-dtrace=auto",
                          "--with-jvm-variants=server",
                          ("--with-x=#{HOMEBREW_PREFIX}" unless OS.mac?),
                          ("--with-cups=#{HOMEBREW_PREFIX}" unless OS.mac?),
                          ("--with-fontconfig=#{HOMEBREW_PREFIX}" unless OS.mac?)

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images"

    if OS.mac?
      libexec.install "build/macosx-x86_64-server-release/images/jdk-bundle/jdk-#{short_version}.jdk" => "openjdk.jdk"
      bin.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/bin/*"]
      include.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/include/*.h"]
      include.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/include/darwin/*.h"]
    else
      libexec.install Dir["build/linux-x86_64-normal-server-release/images/jdk/*"]
      bin.install_symlink Dir["#{libexec}/bin/*"]
      include.install_symlink Dir["#{libexec}/include/*.h"]
      include.install_symlink Dir["#{libexec}/include/linux/*.h"]
    end
  end

  def caveats
    <<~EOS
      For the system Java wrappers to find this JDK, symlink it with
        sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
    EOS
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    EOS

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end
