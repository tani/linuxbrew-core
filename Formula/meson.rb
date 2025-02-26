class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.55.0/meson-0.55.0.tar.gz"
  sha256 "0a1ae2bfe2ae14ac47593537f93290fb79e9b775c55b4c53c282bc3ca3745b35"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2f25cb6f38a6e9d8dad19da2420d8efb1641e9ef2e2e5fa8f473e8707ba8bde" => :catalina
    sha256 "a2f25cb6f38a6e9d8dad19da2420d8efb1641e9ef2e2e5fa8f473e8707ba8bde" => :mojave
    sha256 "a2f25cb6f38a6e9d8dad19da2420d8efb1641e9ef2e2e5fa8f473e8707ba8bde" => :high_sierra
    sha256 "beadc40642df1c9198e6106d8536f173869274c7f44f9a822d0772557dd21129" => :x86_64_linux
  end

  depends_on "ninja"
  depends_on "python@3.8"

  def install
    version = Language::Python.major_minor_version Formula["python@3.8"].bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system Formula["python@3.8"].bin/"python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
