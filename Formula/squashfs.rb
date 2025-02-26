class Squashfs < Formula
  desc "Compressed read-only file system for Linux"
  homepage "https://github.com/plougher/squashfs-tools"
  url "https://github.com/plougher/squashfs-tools/archive/4.4.tar.gz"
  sha256 "a7fa4845e9908523c38d4acf92f8a41fdfcd19def41bd5090d7ad767a6dc75c3"
  license "GPL-2.0"
  head "https://github.com/plougher/squashfs-tools",
    :using  => :git,
    :commit => "52eb4c279cd283ed9802dd1ceb686560b22ffb67"

  bottle do
    cellar :any
    sha256 "e8657da9ab4faa089486fd3af04a3f0b63b13e609cdde57be57d92336592297a" => :catalina
    sha256 "f3e200ecf28cf1fec5fb11e1cd210d8e935db314c39bda62095614e08d9e7477" => :mojave
    sha256 "855306e06f9eeaa7b3cb8960f0c75fe097921a2b99efe8064a6cc97c8b2f579b" => :high_sierra
    sha256 "e318da56d36a0edbf1095a795f4a797d4919f8f859116fc8dc2448088ea0dfe1" => :sierra
    sha256 "7dd927d35cb864cf95dd71f8e41a5267d8fbde83c4658cbf139813668d10d3a8" => :x86_64_linux
  end

  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "zlib"

  # Patch necessary to emulate the sigtimedwait process otherwise we get build failures.
  # Also clang fixes, extra endianness knowledge and a bundle of other macOS fixes.
  patch do
    url "https://github.com/plougher/squashfs-tools/pull/69.patch?full_index=1"
    sha256 "eb399705d259346473ebe5d43b886b278abc66d822ee4193b7c65b4a2ca903da"
  end

  # Fixes the following compilation issue of squash4.3 with newer versions of gcc:
  # "mksquashfs.c:987:24: error: called object 'major' is not a function or function pointer"
  patch do
    url "https://raw.githubusercontent.com/rchikhi/formula-patches/14e9deef14117908e24c17b81b60b11996688991/squashfs/squashfs-new-gcc.diff"
    sha256 "24e51ef16f6e6101b59f4913aa4acbd6ff541a1953e923019e8648f6e6bdd582"
  end

  def install
    args = %W[
      EXTRA_CFLAGS=-std=gnu89
      LZ4_DIR=#{Formula["lz4"].opt_prefix}
      LZ4_SUPPORT=1
      LZO_DIR=#{Formula["lzo"].opt_prefix}
      LZO_SUPPORT=1
      XZ_DIR=#{Formula["xz"].opt_prefix}
      XZ_SUPPORT=1
      LZMA_XZ_SUPPORT=1
      ZSTD_DIR=#{Formula["zstd"].opt_prefix}
      ZSTD_SUPPORT=1
      XATTR_SUPPORT=1
    ]

    cd "squashfs-tools" do
      system "make", *args
      bin.install %w[mksquashfs unsquashfs]
    end

    doc.install %w[README-4.4 RELEASE-READMEs USAGE COPYING]
  end

  test do
    # Check binaries execute
    assert_match version.to_s, shell_output("#{bin}/mksquashfs -version")
    assert_match version.to_s, shell_output("#{bin}/unsquashfs -v", 1)

    (testpath/"in/test1").write "G'day!"
    (testpath/"in/test2").write "Bonjour!"
    (testpath/"in/test3").write "Moien!"

    # Test mksquashfs can make a valid squashimg.
    #   (Also tests that `xz` support is properly linked.)
    system "#{bin}/mksquashfs", "in/test1", "in/test2", "in/test3", "test.xz.sqsh", "-quiet", "-comp", "xz"
    assert_predicate testpath/"test.xz.sqsh", :exist?
    assert_match "Found a valid SQUASHFS 4:0 superblock on test.xz.sqsh.",
      shell_output("#{bin}/unsquashfs -s test.xz.sqsh")

    # Test unsquashfs can extract files verbatim.
    system "#{bin}/unsquashfs", "-d", "out", "test.xz.sqsh"
    assert_predicate testpath/"out/test1", :exist?
    assert_predicate testpath/"out/test2", :exist?
    assert_predicate testpath/"out/test3", :exist?
    assert shell_output("diff -r in/ out/")
  end
end
