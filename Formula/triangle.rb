class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v1.0.5.tar.gz"
  sha256 "3e3e4338ae2b55a21cc742bd5c1c542a778fa0764b17a8f599099f7bf1eb257b"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fb744b3878eb0a3b661b939155929dd3e24050b6bdf79a21926309b9e37c030" => :catalina
    sha256 "e9028dc0560174e50099fdb6efc3dcbb8ed75a8cfc983e2b923a18f54acb1807" => :mojave
    sha256 "aca7f95503e929a3bc8b585e64177dec4d8625bd3d365b18d8fecc8fa463a859" => :high_sierra
    sha256 "48ae218b4ecdf86ebe47e77d1d88661675a466bf98e7521b85373297d5504525" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    dir = buildpath/"src/github.com/esimov/triangle"

    dir.install buildpath.children

    cd dir/"cmd/triangle" do
      system "go", "install"
    end
  end

  test do
    system "#{bin}/triangle", "-in", test_fixtures("test.png"), "-out", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
