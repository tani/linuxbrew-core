class PostgresqlAT95 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v9.5.22/postgresql-9.5.22.tar.bz2"
  sha256 "48555470a17248cb204d25ab1ad4231ef16295db55161922f006b9942d69640f"
  revision OS.mac? ? 2 : 3

  bottle do
    sha256 "33a794b7202e738223650d25749061b779dba8a88f34078ed2d966635605d234" => :catalina
    sha256 "192a8daaddd008b006953bec273ae12e4c0238c4c0b34ec9f7008e15654234d3" => :mojave
    sha256 "5948803273679d81c357096eabca041fbbaaf7689b5caba8d7b2b745434750a9" => :high_sierra
    sha256 "f920cc7b5e9b055a98021202b99d985b5a20dcafca53e200f3c3f1199f685814" => :x86_64_linux
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxslt"
  uses_from_macos "perl"

  on_linux do
    depends_on "util-linux"
  end

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@1.1"].opt_include} -I#{Formula["readline"].opt_include}"

    # avoid adding the SDK library directory to the linker search path
    ENV["XML2_CONFIG"] = "xml2-config --exec-prefix=/usr"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{pkgshare}
      --libdir=#{lib}
      --sysconfdir=#{prefix}/etc
      --docdir=#{doc}
      --enable-thread-safety
      --with-libxml
      --with-libxslt
      --with-openssl
      --with-perl
      --with-uuid=e2fs
    ]
    if OS.mac?
      args += %w[
        --with-bonjour
        --with-gssapi
        --with-ldap
        --with-pam
        --with-tcl
      ]
    end

    # PostgreSQL by default uses xcodebuild internally to determine this,
    # which does not work on CLT-only installs.
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if MacOS.sdk_root_needed?

    system "./configure", *args
    system "make"

    dirs = %W[datadir=#{pkgshare} libdir=#{lib} pkglibdir=#{lib}]

    # Temporarily disable building/installing the documentation.
    # Postgresql seems to "know" the build system has been altered and
    # tries to regenerate the documentation when using `install-world`.
    # This results in the build failing:
    #  `ERROR: `osx' is missing on your system.`
    # Attempting to fix that by adding a dependency on `open-sp` doesn't
    # work and the build errors out on generating the documentation, so
    # for now let's simply omit it so we can package Postgresql for Mojave.
    if DevelopmentTools.clang_build_version >= 1000
      system "make", "all"
      system "make", "-C", "contrib", "install", "all", *dirs
      system "make", "install", "all", *dirs
    else
      system "make", "install-world", *dirs
    end

    unless OS.mac?
      inreplace lib/"pgxs/src/Makefile.global",
                "LD = #{HOMEBREW_PREFIX}/Homebrew/Library/Homebrew/shims/linux/super/ld",
                "LD = #{HOMEBREW_PREFIX}/bin/ld"
    end
  end

  def post_install
    return if ENV["CI"]

    (var/"log").mkpath
    (var/name).mkpath
    system "#{bin}/initdb", "#{var}/#{name}" unless File.exist? "#{var}/#{name}/PG_VERSION"
  end

  def caveats
    <<~EOS
      If builds of PostgreSQL 9 are failing and you have version 8.x installed,
      you may need to remove the previous version first. See:
        https://github.com/Homebrew/legacy-homebrew/issues/2510

      To migrate existing data from a previous major version (pre-9.0) of PostgreSQL, see:
        https://www.postgresql.org/docs/9.5/static/upgrading.html

      To migrate existing data from a previous minor version (9.0-9.4) of PostgreSQL, see:
        https://www.postgresql.org/docs/9.5/static/pgupgrade.html

        You will need your previous PostgreSQL installation from brew to perform `pg_upgrade`.
        Do not run `brew cleanup postgresql@9.5` until you have performed the migration.
    EOS
  end

  plist_options :manual => "pg_ctl -D #{HOMEBREW_PREFIX}/var/postgresql@9.5 start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/postgres</string>
          <string>-D</string>
          <string>#{var}/#{name}</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/#{name}.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/initdb", testpath/"test" unless ENV["CI"]
    assert_equal pkgshare.to_s, shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal lib.to_s, shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal lib.to_s, shell_output("#{bin}/pg_config --pkglibdir").chomp
  end
end
