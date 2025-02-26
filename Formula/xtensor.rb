class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xtensor/archive/0.21.5.tar.gz"
  sha256 "30cb896b6686683ddaefb12c98bf1109fdfe666136dd027aba1a1e9aa825c241"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "885a150c2923a6b90f592284e406b39b2b7fc736ea3ba83ac1d2486f48ef440e" => :catalina
    sha256 "885a150c2923a6b90f592284e406b39b2b7fc736ea3ba83ac1d2486f48ef440e" => :mojave
    sha256 "885a150c2923a6b90f592284e406b39b2b7fc736ea3ba83ac1d2486f48ef440e" => :high_sierra
    sha256 "c82c6571e7a7da7015e0f36c5f480a616a85da8017a8697170f2481d0c744f63" => :x86_64_linux
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/xtensor-stack/xtl/archive/0.6.13.tar.gz"
    sha256 "12bd628dee4a7a55db79bff5a47fb7d96b1a4dba780fbd5c81c3a15becfdd99c"
  end

  def install
    resource("xtl").stage do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end

    system "cmake", ".", "-Dxtl_DIR=#{lib}/cmake/xtl", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include "xtensor/xarray.hpp"
      #include "xtensor/xio.hpp"
      #include "xtensor/xview.hpp"

      int main() {
        xt::xarray<double> arr1
          {{11.0, 12.0, 13.0},
           {21.0, 22.0, 23.0},
           {31.0, 32.0, 33.0}};

        xt::xarray<double> arr2
          {100.0, 200.0, 300.0};

        xt::xarray<double> res = xt::view(arr1, 1) + arr2;

        std::cout << res(2) << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-o", "test", "-I#{include}"
    assert_equal "323", shell_output("./test").chomp
  end
end
