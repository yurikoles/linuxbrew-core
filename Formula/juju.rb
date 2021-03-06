class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.7/2.7.5/+download/juju-core_2.7.5.tar.gz"
  sha256 "096c2ea02f6262d85dfb1915d34b3be2f6832b224555f8d8e99631a4b9f785b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "87af16f9ff4737c802b9e1133bae2ef16beb4285891c3dd0897952df43f5d928" => :catalina
    sha256 "1aa5b7f833f25435fb885e2e6329a9997dac828a797b6adefa7304d8701a4e0c" => :mojave
    sha256 "3fada9273fc507fcef727d0c6ea339963f97393b7aac88da7136fc981e6a9120" => :high_sierra
    sha256 "03b028104019b2a3d069e96910146578d77d3e74cab766b9fe93ee1be2b8e46e" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
