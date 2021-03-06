require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.17.5.tar.gz"
  sha256 "385e5b5c6c5f962073764ceb2350326ce6effef5304135b20bea04427dccbe1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a878f0f34ce987a40bc2d5e7a7c4cb9afeebcaa657793eaaf15d9bc025b6f591" => :catalina
    sha256 "ec4f7290b4a57dafdf8a66543b87a04e9dd9aac590e5810a82779888e396fec3" => :mojave
    sha256 "2a7e7a9198c8220f0c8ea4a259606cddad3787e02bed7f05d5071394f40548b8" => :high_sierra
    sha256 "042660292f0e2665aeee8cf10ce152ae7693e43b55f6cbafd6ef8897d646947d" => :x86_64_linux
  end

  depends_on "haskell-stack" => :build
  uses_from_macos "xz"
  depends_on "gmp" unless OS.mac?

  def install
    unless OS.mac?
      gmp = Formula["gmp"]
      ENV.prepend_path "LD_LIBRARY_PATH", gmp.lib
      ENV.prepend_path "LIBRARY_PATH", gmp.lib
    end

    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    system "stack", "-j#{jobs}", "build"
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
