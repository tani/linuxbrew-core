class Mikutter < Formula
  desc "Extensible Twitter client"
  homepage "https://mikutter.hachune.net/"
  url "https://mikutter.hachune.net/bin/mikutter-4.0.6.tar.gz"
  sha256 "3ac0292aafbbd6a8f978091244ef20f3911ecb1c26a85e8e3c6ef86211f279cd"
  license "MIT"
  head "git://mikutter.hachune.net/mikutter.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "cb4bba033f7a9e68459cdb2bbb8a3a19a3d6d174784b227f4f2da1fba6978725" => :catalina
    sha256 "59caaf25a9766b967d2388c2b3de3563fd5f02c645a4d477eec387003f8afe3e" => :mojave
    sha256 "371302f304c78f0c79acef28bdb32d9cbb61030cde9e5f45f6d262a92d101167" => :high_sierra
    sha256 "09243ab97d8c59ce677e6aa39ca355a6268b425162f6edaad00f687f163fc4f1" => :x86_64_linux
  end

  depends_on "gobject-introspection"
  depends_on "gtk+"
  depends_on "libidn"
  depends_on "ruby"
  depends_on "terminal-notifier" if OS.mac?

  uses_from_macos "xz"

  resource "addressable" do
    url "https://rubygems.org/downloads/addressable-2.7.0.gem"
    sha256 "5e9b62fe1239091ea9b2893cd00ffe1bcbdd9371f4e1d35fac595c98c5856cbb"
  end

  resource "atk" do
    url "https://rubygems.org/downloads/atk-3.4.1.gem"
    sha256 "88240dd7f28f38d05349363585827df2da258412c531744bf18f74e3824a1829"
  end

  resource "cairo" do
    url "https://rubygems.org/downloads/cairo-1.16.5.gem"
    sha256 "f11f243d74b6902bb0306c860e17b8be530883a617b0ece1abe488ab40085bba"
  end

  resource "cairo-gobject" do
    url "https://rubygems.org/downloads/cairo-gobject-3.4.1.gem"
    sha256 "4800f1dc9720640060ba63602e235fa5f5b7469434c68788ce3c6f46b56b7d3e"
  end

  resource "delayer" do
    url "https://rubygems.org/downloads/delayer-1.0.2.gem"
    sha256 "b5bc78b8d1b484021d91ce630e9d10b4a87ccd8925b2760799f3193d38203842"
  end

  resource "delayer-deferred" do
    url "https://rubygems.org/downloads/delayer-deferred-2.1.3.gem"
    sha256 "cd1464eb228d4c08ba29af200a28892dde32c4d3f39e6fe6300c7a3c148686de"
  end

  resource "diva" do
    url "https://rubygems.org/downloads/diva-1.0.2.gem"
    sha256 "4f702b8fee7e737847c25324807f47206d4402969f929b2d7976ef531e279417"
  end

  resource "gdk_pixbuf2" do
    url "https://rubygems.org/downloads/gdk_pixbuf2-3.4.1.gem"
    sha256 "55dd9255105b81954c3f49c0669e26262380eea634b323017454c509ec7f2405"
  end

  resource "gettext" do
    url "https://rubygems.org/gems/gettext-3.3.5.gem"
    sha256 "955f115e1099ea705949c4e221164efdbbf07ec6e148131a777873c0f419bb04"
  end

  resource "gio2" do
    url "https://rubygems.org/downloads/gio2-3.4.1.gem"
    sha256 "efd470c1b32641bce0df4ec689a2770d19503a7f98cd5b19eca5acddd6bb72d0"
  end

  resource "glib2" do
    url "https://rubygems.org/downloads/glib2-3.4.1.gem"
    sha256 "2c60c23752cb62cd82feab5d640844876e6e1a5e2226372d550582eb80f594a1"
  end

  resource "gobject-introspection" do
    url "https://rubygems.org/downloads/gobject-introspection-3.4.1.gem"
    sha256 "5680367a577bc1d5a0145d8da26a516b946c0c2f14c91f411f5d2d1d23467da8"
  end

  resource "gtk2" do
    url "https://rubygems.org/downloads/gtk2-3.4.1.gem"
    sha256 "ad8ae7763cc3e8658e8dd4eca31a639880b8d485e2c9d52648fffb60c1435f9d"
  end

  resource "httpclient" do
    url "https://rubygems.org/gems/httpclient-2.8.3.gem"
    sha256 "2951e4991214464c3e92107e46438527d23048e634f3aee91c719e0bdfaebda6"
  end

  resource "instance_storage" do
    url "https://rubygems.org/gems/instance_storage-1.0.0.gem"
    sha256 "f41e64da2fe4f5f7d6c8cf9809ef898e660870f39d4e5569c293b584a12bce22"
  end

  resource "locale" do
    url "https://rubygems.org/downloads/locale-2.1.3.gem"
    sha256 "b6ddee011e157817cb98e521b3ce7cb626424d5882f1e844aafdee3e8b212725"
  end

  resource "memoist" do
    url "https://rubygems.org/downloads/memoist-0.16.2.gem"
    sha256 "a52c53a3f25b5875151670b2f3fd44388633486dc0f09f9a7150ead1e3bf3c45"
  end

  resource "mini_portile2" do
    url "https://rubygems.org/gems/mini_portile2-2.4.0.gem"
    sha256 "7e178a397ad62bb8a96977986130dc81f1b13201c6dd95a48bd8cec1dda5f797"
  end

  resource "moneta" do
    url "https://rubygems.org/downloads/moneta-1.3.0.gem"
    sha256 "38ffd4f10d3a2f48ad8362eaf63f619da89ca2b5d5a0bae2f8447ce4880f9590"
  end

  resource "native-package-installer" do
    url "https://rubygems.org/downloads/native-package-installer-1.0.9.gem"
    sha256 "80bad0273706eeb4fc49ac8fa589b25eb6728c85a09fd241c8f0f06bdca32c5e"
  end

  resource "nokogiri" do
    url "https://rubygems.org/downloads/nokogiri-1.10.9.gem"
    sha256 "d562108c5cdf7e9208c267107a0a54581d868689aefed9c5480898bb4033478a"
  end

  resource "oauth" do
    url "https://rubygems.org/gems/oauth-0.5.4.gem"
    sha256 "3e017ed1c107eb6fe42c977b78c8a8409249869032b343cf2f23ac80d16b5fff"
  end

  resource "pango" do
    url "https://rubygems.org/downloads/pango-3.4.1.gem"
    sha256 "77e14073e93bbddb53ad6e3debf3e054f5444de4e2748c36cb2ede8741b10cb4"
  end

  resource "pkg-config" do
    url "https://rubygems.org/downloads/pkg-config-1.4.1.gem"
    sha256 "dca87a58534dfc3ff61c5de1289ed6622a5bd1f5b48fb2dc7a1cc5ef8f6b4ef2"
  end

  resource "pluggaloid" do
    url "https://rubygems.org/gems/pluggaloid-1.2.0.gem"
    sha256 "108eb89db1cc35f94f69d838f673d9d501b7e1f57e8eec5e200cb1d8a4cc60bf"
  end

  resource "public_suffix" do
    url "https://rubygems.org/downloads/public_suffix-4.0.5.gem"
    sha256 "efbc976b8f8cd7e2f9387b41ad4dc5447bcc7e862cf3afd909f13b0048a3dc6f"
  end

  resource "rake" do
    url "https://rubygems.org/downloads/rake-13.0.1.gem"
    sha256 "292a08eb3064e972e3e07e4c297d54a93433439ff429e58a403ae05584fad870"
  end

  resource "text" do
    url "https://rubygems.org/gems/text-1.3.1.gem"
    sha256 "2fbbbc82c1ce79c4195b13018a87cbb00d762bda39241bb3cdc32792759dd3f4"
  end

  resource "typed-array" do
    url "https://rubygems.org/gems/typed-array-0.1.2.gem"
    sha256 "891fa1de2cdccad5f9e03936569c3c15d413d8c6658e2edfe439d9386d169b62"
  end

  # This is annoying - if the gemfile lists test group gems at all,
  # even if we've explicitly requested to install without them,
  # bundle install --cache will fail because it can't find those gems.
  # Handle this by modifying the gemfile to remove these gems.
  def gemfile_remove_test!
    gemfile_lines = []
    test_group = false
    File.read("Gemfile").each_line do |line|
      line.chomp!

      # If this is the closing part of the test group,
      # swallow this line and then allow writing the test of the file.
      if test_group && line == "end"
        test_group = false
        next
      # If we're still inside the test group, skip writing.
      elsif test_group
        next
      end

      # If this is the start of the test group, skip writing it and mark
      # this as part of the group.
      if line.include?("group :test")
        test_group = true
      else
        gemfile_lines << line
      end
    end

    File.open("Gemfile", "w") do |gemfile|
      gemfile.puts gemfile_lines.join("\n")
      # Unmarked dependency of atk
      gemfile.puts "gem 'rake','>= 13.0.1'"
    end
  end

  def install
    (lib/"mikutter/vendor").mkpath
    (buildpath/"vendor/cache").mkpath
    resources.each do |r|
      r.unpack buildpath/"vendor/cache"
    end

    gemfile_remove_test!
    system "bundle", "install",
           "--local", "--path=#{lib}/mikutter/vendor"

    rm_rf "vendor"
    (lib/"mikutter").install "plugin"
    libexec.install Dir["*"]

    ruby_series = Formula["ruby"].version.to_s.split(".")[0..1].join(".")
    env = {
      :DISABLE_BUNDLER_SETUP => "1",
      :GEM_HOME              => HOMEBREW_PREFIX/"lib/mikutter/vendor/ruby/#{ruby_series}.0",
      :GTK_PATH              => HOMEBREW_PREFIX/"lib/gtk-2.0",
    }

    (bin/"mikutter").write_env_script Formula["ruby"].opt_bin/"ruby", "#{libexec}/mikutter.rb", env
    pkgshare.install_symlink libexec/"core/skin"

    # enable other formulae to install plugins
    libexec.install_symlink HOMEBREW_PREFIX/"lib/mikutter/plugin"
  end

  test do
    (testpath/".mikutter/plugin/test_plugin/test_plugin.rb").write <<~EOS
      # -*- coding: utf-8 -*-
      Plugin.create(:test_plugin) do
        require 'logger'

        Delayer.new do
          log = Logger.new(STDOUT)
          log.info("loaded test_plugin")
          exit
        end
      end

      # this is needed in order to boot mikutter >= 3.6.0
      class Post
        def self.primary_service
          nil
        end
      end
    EOS
    system bin/"mikutter", "plugin_depends",
           testpath/".mikutter/plugin/test_plugin/test_plugin.rb"
    system bin/"mikutter", "--plugin=test_plugin", "--debug"
  end
end
