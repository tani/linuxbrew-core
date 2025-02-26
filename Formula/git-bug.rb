class GitBug < Formula
  desc "Distributed, offline-first bug tracker embedded in git, with bridges"
  homepage "https://github.com/MichaelMure/git-bug"
  url "https://github.com/MichaelMure/git-bug.git",
    :tag      => "0.7.1",
    :revision => "2d64b85db71a17ff3277bbbf7ac9d8e81f8e416c"
  license "GPL-3.0"
  head "https://github.com/MichaelMure/git-bug.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b22d352d4f7ac655ab3544593cbdbcb1d1ad6e2f87dd0f7066e31a9319aa97b" => :catalina
    sha256 "c5a308416b902fbd59bd1df0bd17074f5bc9d8de594a07573b8d074889cb45fd" => :mojave
    sha256 "0617df6821ac81888aa4ba8b38102031b17fb64b6b25b20554a454e3e4a1fd60" => :high_sierra
    sha256 "1f8113daac2c7f44130d4b7df8dfb8103a2bfb70842da653945e39c55f2bacf1" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    man1.install Dir["doc/man/*.1"]
    doc.install Dir["doc/md/*.md"]
    bash_completion.install "misc/bash_completion/git-bug"
    zsh_completion.install "misc/zsh_completion/git-bug" => "_git-bug"
  end

  test do
    # Version
    assert_match version.to_s, shell_output("#{bin}/git-bug --version")
    # Version through git
    assert_match version.to_s, shell_output("git bug --version")

    mkdir testpath/"git-repo" do
      system "git", "init"
      system "git", "config", "user.name", "homebrew"
      system "git", "config", "user.email", "a@a.com"
      system "yes 'a b http://www/www' | git bug user create"
      system "git", "bug", "add", "-t", "Issue 1", "-m", "Issue body"
      system "git", "bug", "add", "-t", "Issue 2", "-m", "Issue body"
      system "git", "bug", "add", "-t", "Issue 3", "-m", "Issue body"

      assert_match "Issue 2", shell_output("git bug ls")
    end
  end
end
