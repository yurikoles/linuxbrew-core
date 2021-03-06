class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.5.2/fwup-1.5.2.tar.gz"
  sha256 "d82ce3c70335170bd8f1ebe10940585c8a797521a8c35ad85aa34a52e8d4341e"

  bottle do
    cellar :any
    sha256 "8f26f8b0c20a3cc285b27b9327bf7e1a2617224b3003e04c143eae0dd11d31ae" => :catalina
    sha256 "37c5e77fc5ccc270944e061a6c618194f7ce7e4398be7984fdc3f5cbd765a8eb" => :mojave
    sha256 "b0304fd711a820de849bd4554b16b4a037414b82cc55bcb845b6983193ac8ed2" => :high_sierra
    sha256 "b08465d3fc36f4408ea6d40d891e5c48c71eb441855567e18a1c48a0e51473ed" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
