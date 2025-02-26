class Gl2ps < Formula
  desc "OpenGL to PostScript printing library"
  homepage "https://www.geuz.org/gl2ps/"
  url "https://geuz.org/gl2ps/src/gl2ps-1.4.2.tgz"
  sha256 "8d1c00c1018f96b4b97655482e57dcb0ce42ae2f1d349cd6d4191e7848d9ffe9"

  bottle do
    cellar :any
    sha256 "dbdfe5d8458e1224941d6e5707b725ab6872333112dc408dbf35202eddbc8d15" => :catalina
    sha256 "bc857ec44c73448acf748dea7a699e1018a874196dec19659a63aa70a7b5e970" => :mojave
    sha256 "6c36dc780b0579f44057cadddb9e1a2e369e2ba9205b68d6c81ebd79defc45b4" => :high_sierra
    sha256 "0c30fbb5197067a5d5de6d491a4ed79e8457e6a91eaed031cd3d1a1737fc7f04" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  on_linux do
    depends_on "freeglut"
  end

  def install
    # Prevent linking against X11's libglut.dylib when it's present
    # Reported to upstream's mailing list gl2ps@geuz.org (1st April 2016)
    # https://www.geuz.org/pipermail/gl2ps/2016/000433.html
    # Reported to cmake's bug tracker, as well (1st April 2016)
    # https://public.kitware.com/Bug/view.php?id=16045
    args = std_cmake_args
    args << "-DGLUT_glut_LIBRARY=/System/Library/Frameworks/GLUT.framework" if OS.mac?
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <#{OS.mac? ? "GLUT" : "GL"}/glut.h>
      #include <gl2ps.h>

      int main(int argc, char *argv[])
      {
        glutInit(&argc, argv);
        glutInitDisplayMode(GLUT_DEPTH);
        glutInitWindowSize(400, 400);
        glutInitWindowPosition(100, 100);
        glutCreateWindow(argv[0]);
        GLint viewport[4];
        glGetIntegerv(GL_VIEWPORT, viewport);
        FILE *fp = fopen("test.eps", "wb");
        GLint buffsize = 0, state = GL2PS_OVERFLOW;
        while( state == GL2PS_OVERFLOW ){
          buffsize += 1024*1024;
          gl2psBeginPage ( "Test", "Homebrew", viewport,
                           GL2PS_EPS, GL2PS_BSP_SORT, GL2PS_SILENT |
                           GL2PS_SIMPLE_LINE_OFFSET | GL2PS_NO_BLENDING |
                           GL2PS_OCCLUSION_CULL | GL2PS_BEST_ROOT,
                           GL_RGBA, 0, NULL, 0, 0, 0, buffsize,
                           fp, "test.eps" );
          gl2psText("Homebrew Test", "Courier", 12);
          state = gl2psEndPage();
        }
        fclose(fp);
        return 0;
      }
    EOS
    if OS.mac?
      system ENV.cc, "-L#{lib}", "-lgl2ps", "-framework", "OpenGL", "-framework",
                     "GLUT", "-framework", "Cocoa", "test.c", "-o", "test"
    else
      system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lgl2ps", "-lglut", "-lGL"
      # Fails without an X11 display: freeglut (./test): failed to open display ''
      return if ENV["CI"]
    end
    system "./test"
    assert_predicate testpath/"test.eps", :exist?
    assert_predicate File.size("test.eps"), :positive?
  end
end
