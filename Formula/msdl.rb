class Msdl < Formula
  desc "Downloader for various streaming protocols"
  homepage "https://msdl.sourceforge.io"
  url "https://downloads.sourceforge.net/msdl/msdl-1.2.7-r2.tar.gz"
  version "1.2.7-r2"
  sha256 "0297e87bafcab885491b44f71476f5d5bfc648557e7d4ef36961d44dd430a3a1"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "71fb71cf2c24085221ee1d24c57fbe07f1b6cc437d84385d22231a4723771207" => :catalina
    sha256 "30deed1f7ba83c707aa002a217438e341aae978e27cfc6d39239a063f2b14cde" => :mojave
    sha256 "5f2922fa4f3b69f3f00cb7e29854c5a43c163e209c87d961253da9c4a7c3ec73" => :high_sierra
    sha256 "69b04b6f10ea552b6c862110434cc63dfa6bfccdc8034edd70fed5db0f79e68b" => :sierra
    sha256 "34ba320e82d1ce97fb0a106abd2c5ec848ba16857730ba51cadd0a030bee62ab" => :el_capitan
    sha256 "5b8ac26e3adbb19386398a5500a8d5631d426b2e0e951433134b5383b80bb568" => :yosemite
    sha256 "a28059bba6256df7233eacbfdadd9eeec2c3c6ec22038cb06ca49745b347a828" => :mavericks
    sha256 "b01b19503e91ce46bef0f624d11eff53bdfafb686dbae616a9ab21f297240ffd" => :x86_64_linux
  end

  # Fixes linker error under clang; apparently reported upstream:
  # https://github.com/Homebrew/homebrew/pull/13907
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/src/url.c b/src/url.c
index 81783c7..356883a 100644
--- a/src/url.c
+++ b/src/url.c
@@ -266,7 +266,7 @@ void url_unescape_string(char *dst,char *src)
 /*
  * return true if 'c' is valid url character
  */
-inline int is_url_valid_char(int c)
+int is_url_valid_char(int c)
 {
     return (isalpha(c) ||
	    isdigit(c) ||
