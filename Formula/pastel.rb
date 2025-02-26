class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/v0.8.0.tar.gz"
  sha256 "603dc63d6aa261f159178dffeb389471a845c1a5d62187a275a3d33a66fe9a69"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2478748ed0561c76af8f68b4067f42cd365ad7735a9d44dda159e9bd35a1c1d" => :catalina
    sha256 "3d9fcb9c4f2e70010681b88f0ceca5795773b849e7bc6f59689e90ad969a673c" => :mojave
    sha256 "06f87da95e1d1b0f53fbcd9c9ff36e4c8a0d3ea85825ac7bc648b3ab445e61ee" => :high_sierra
    sha256 "921f26cbdd5e4fedce06655961f8c8786bf0b35677f82348909d1a6d0af03198" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath/"completions"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/pastel.bash"
    zsh_completion.install "completions/_pastel"
    fish_completion.install "completions/pastel.fish"
  end

  test do
    output = shell_output("#{bin}/pastel format hex rebeccapurple").strip

    assert_equal "#663399", output
  end
end
