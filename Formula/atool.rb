class Atool < Formula
  desc "Archival front-end"
  homepage "https://savannah.nongnu.org/projects/atool/"
  url "https://savannah.nongnu.org/download/atool/atool-0.39.0.tar.gz"
  sha256 "aaf60095884abb872e25f8e919a8a63d0dabaeca46faeba87d12812d6efc703b"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "78769c7244232e9ba4b403f0dae560e61bc69d08d76936e9797c3f9b18b778f3" => :catalina
    sha256 "afc78205d3558294d008a801f7b06e8fcc94509a34bb0832f914575c196d6f8d" => :mojave
    sha256 "0f28ddbd664675c6b3fe440f6cfba6ac8cc6fc1f97141979bbce485080a759f4" => :high_sierra
    sha256 "656b59fcaa79956c81af4ce21afc06dbf9f6ffaecc0ff52b1a063da2c911fe89" => :sierra
    sha256 "dcfdcb720aa3704b9103aa01bb8efac42d24327bc8664baa420a9a69d75a98b6" => :el_capitan
    sha256 "efdeeb165e146f4a76477417d2af9c60e2f776d06081bb579ff73ceb296a899d" => :yosemite
    sha256 "4eed286344a3a1d4fc6efc908b34062b5cc7c7fdf2449cf85b7767168585fc7a" => :mavericks
    sha256 "7c908cc1f52028e534fb1c085b492506ea04ecf663a8159b1469d8d13221ee84" => :x86_64_linux # glibc 2.19
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "apple_juice"
    cd testpath/"apple_juice" do
      touch "example.txt"
      touch "example2.txt"
      system bin/"apack", "test.tar.gz", "example.txt", "example2.txt"
    end
    output = shell_output("#{bin}/als #{testpath}/apple_juice/test.tar.gz")
    assert_match "example.txt", output
    assert_match "example2.txt", output
  end
end
