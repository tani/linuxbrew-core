class Pdf2json < Formula
  desc "PDF to JSON and XML converter"
  homepage "https://github.com/flexpaper/pdf2json"
  url "https://github.com/flexpaper/pdf2json/archive/0.71.tar.gz"
  sha256 "54878473a2afb568caf2da11d6804cabe0abe505da77584a3f8f52bcd37d9c55"

  bottle do
    cellar :any_skip_relocation
    sha256 "035c69de85f1cad569ff743faef796a88b9f9a706be802bf111a83505858b366" => :catalina
    sha256 "abf950838b700f50ff4279501533176cb5a1929fb0b88c8ccf94b07ac362c66d" => :mojave
    sha256 "4bee4b8c61362c64d72a3f011f8c5ef223c5e80d269e442a18472adc42e108e9" => :high_sierra
    sha256 "d12d466dbb2fcd6061b2138034e14a81b9dbc241dd1496d9cad2013f036a5f9c" => :x86_64_linux
  end

  def install
    system "./configure"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install "src/pdf2json"
  end

  test do
    system bin/"pdf2json", test_fixtures("test.pdf"), "test.json"
    assert_predicate testpath/"test.json", :exist?
  end
end
