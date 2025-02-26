class Rarian < Formula
  desc "Documentation metadata library"
  homepage "https://rarian.freedesktop.org/"
  url "https://rarian.freedesktop.org/Releases/rarian-0.8.1.tar.bz2"
  sha256 "aafe886d46e467eb3414e91fa9e42955bd4b618c3e19c42c773026b205a84577"

  bottle do
    sha256 "6cd01a0bbc9d5168548c6735ddf1057ae3ef403d3868be499ff1ce3ba1cd6ab8" => :catalina
    sha256 "e727630f28efcdcb1a577f67525992f00a00c25ee1582277e1e91e2fa060187d" => :mojave
    sha256 "815aafc0d05198cd4e3880715a6ad5de21b3bf47ccf25ef4b91aa918848a67ee" => :high_sierra
    sha256 "9266addbd38ed67b7394d05702d2be69d44ccafeb8132ef75470a816614a9f8e" => :sierra
    sha256 "7784dc13b95c0c2f5818bc3657da52f0365bbe9c6ddf8871d81b8638cb89390c" => :el_capitan
    sha256 "069ff9e17c252271d058e72f38eedb2e1196cee49598e1537c64bd45b7f356e6" => :yosemite
    sha256 "1a81d2fe1bb961b9b479da410046f24fa65df8db7cac5ee0853cc09f380f6bc4" => :mavericks
    sha256 "ee0188851e808392329ccbf64a40eb43b03df5703fc83e74ab1a5f9fbec59235" => :x86_64_linux
  end

  conflicts_with "scrollkeeper",
    :because => "rarian and scrollkeeper install the same binaries"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
