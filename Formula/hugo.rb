class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.74.1.tar.gz"
  sha256 "ecbde28a1e7c0ac7bfdd5ee4726183750c35c789fd1a5f773e61ccd0624bc280"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "510024963d7da638c895b795ae01d364f315ae1846a2a01d7cd1ee46aea409f3" => :catalina
    sha256 "72b9ae7149c8adf7613361a9ae64420a96c55b9a391ab1068f493785a1491768" => :mojave
    sha256 "651e949948cb117730f9542f0768c1b965f01a411aeb231cf095d5b84b83e9d1" => :high_sierra
    sha256 "defc8a9ce65d984a58963770edee24db57b5c2f29fdfc662dc4632f62659147b" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children

    cd "src/github.com/gohugoio/hugo" do
      system "go", "build", "-o", bin/"hugo", "-tags", "extended", "main.go"

      # Build bash completion
      system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
      bash_completion.install "hugo.sh"

      # Build man pages; target dir man/ is hardcoded :(
      (Pathname.pwd/"man").mkpath
      system bin/"hugo", "gen", "man"
      man1.install Dir["man/*.1"]

      prefix.install_metafiles
    end
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
