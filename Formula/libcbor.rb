class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "http://libcbor.org/"
  url "https://github.com/PJK/libcbor/archive/v0.6.1.tar.gz"
  sha256 "2f805f5fa2790c4fdd16046287f5814703229547da2b83009dd32357623aa182"

  bottle do
    cellar :any
    sha256 "9500d9ae8eb7c2048779c7be7c8be643f0f374ca131192c39f6f8ce4c4158173" => :catalina
    sha256 "8a1800894384b8c4a0a2f2190141754dfbdfb2cd56940ae87a7fb6ed704b06a2" => :mojave
    sha256 "6b42f6b810aa4e0cb0d5141491fa5b989413e518ed0134fd39677637999365e4" => :high_sierra
    sha256 "fc572e035aabf30caccdeb7a8b3cc33a8e769f693ee9b65f712aa20bd11098cb" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    # Hack around libcbor forcing LTO for Release builds
    # https://github.com/PJK/libcbor/issues/140
    inreplace "CMakeLists.txt", "-flto", "" unless OS.mac?

    mkdir "build" do
      system "cmake", "..", "-DWITH_EXAMPLES=OFF", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"example.c").write <<-EOS
    #include "cbor.h"
    #include <stdio.h>
    int main(int argc, char * argv[])
    {
    printf("Hello from libcbor %s\\n", CBOR_VERSION);
    printf("Custom allocation support: %s\\n", CBOR_CUSTOM_ALLOC ? "yes" : "no");
    printf("Pretty-printer support: %s\\n", CBOR_PRETTY_PRINTER ? "yes" : "no");
    printf("Buffer growth factor: %f\\n", (float) CBOR_BUFFER_GROWTH);
    }
    EOS

    system ENV.cc, "-std=c99", "example.c", "-L#{lib}", "-lcbor", "-o", "example"
    system "./example"
    puts `./example`
  end
end
