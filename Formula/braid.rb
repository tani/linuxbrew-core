class Braid < Formula
  desc "Simple tool to help track vendor branches in a Git repository"
  homepage "https://cristibalan.github.io/braid/"
  url "https://github.com/cristibalan/braid.git",
      :tag      => "v1.1.3",
      :revision => "74bde1426c2a2713f8a56a879e5ff2e1e4213ad8"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce0e9998210922c07060f09c2eaa814f6b0ad43d3493d830b4a763af5b37857e" => :catalina
    sha256 "9aa11522728149a3adb93ddbf19bcf52d105599377bca4724005d9529ae35683" => :mojave
    sha256 "6fa201d3849284c3e8c04bad3b530b2a478547b5e41acb9ed9203e2d7b39f343" => :high_sierra
    sha256 "dfc5dbab04d6fd62ac13cbc8ba2dcd6ebe87c3fcc1d1645fbf844dbcfb651cea" => :sierra
  end

  depends_on "ruby" if !OS.mac? || MacOS.version <= :sierra

  resource "arrayfields" do
    url "https://rubygems.org/gems/arrayfields-4.9.2.gem"
    sha256 "1593f0bac948e24aa5e5099b7994b0fb5da69b6f29a82804ccf496bc125de4ab"
  end

  resource "chronic" do
    url "https://rubygems.org/gems/chronic-0.10.2.gem"
    sha256 "766f2fcce6ac3cc152249ed0f2b827770d3e517e2e87c5fba7ed74f4889d2dc3"
  end

  if MacOS.version <= :sierra
    resource "json" do
      url "https://rubygems.org/gems/json-2.1.0.gem"
      sha256 "b76fd09b881088c6c64a12721a1528f2f747a1c2ee52fab4c1f60db8af946607"
    end
  end

  resource "fattr" do
    url "https://rubygems.org/gems/fattr-2.3.0.gem"
    sha256 "0430a798270a7097c8c14b56387331808b8d9bb83904ba643b196c895bdf5993"
  end

  resource "main" do
    url "https://rubygems.org/gems/main-6.2.2.gem"
    sha256 "af04ee3eb4b7455eb5ab17e98ab86b0dad8b8420ad3ae605313644a4c6f49675"
  end

  resource "map" do
    url "https://rubygems.org/gems/map-6.6.0.gem"
    sha256 "153a6f384515b14085805f5839d318f9d3c9dab676f341340fa4300150373cbc"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "braid.gemspec"
    system "gem", "install", "--ignore-dependencies", "braid-#{version}.gem"
    bin.install libexec/"bin/braid"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    system "git", "init"
    (testpath/"README").write "Testing"
    (testpath/".gitignore").write "Library"
    system "git", "add", "README", ".gitignore"
    system "git", "commit", "-m", "Initial commit"
    output = shell_output("#{bin}/braid add https://github.com/cristibalan/braid.git")
    assert_match "Braid: Added mirror at '", output
    assert_match "braid (", shell_output("#{bin}/braid status")
  end
end
