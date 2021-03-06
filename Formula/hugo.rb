class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.69.0.tar.gz"
  sha256 "b4db7bf58c9cc722bf1fd70265ce97a743ed720990f22401673f2b612d7c44ec"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e9286b63c118ba008b1fb464d9352f72ffa9694ce24c08f70e7a5da3083ecc6" => :catalina
    sha256 "34e3588c70cd206e8946a97e481d646259e4ddade6a52fb72263c269d4b3ece1" => :mojave
    sha256 "21048f98f1d302e24a4eae2a03e8ec145b9d8a107aa7c6f231f39844c4622cf1" => :high_sierra
    sha256 "dbd363c59c504aefab13d1effb93c2c2b298b697407fa3cc7675c31bdadc0767" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children

    cd "src/github.com/gohugoio/hugo" do
      system "go", "build", "-o", bin/"hugo", "-tags", "extended", "main.go"

      # Build bash completion
      system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
      bash_completion.install "hugo.sh"

      # Build man pages; target dir man/ is hardcoded :(
      (Pathname.pwd/"man").mkpath
      system bin/"hugo", "gen", "man"
      man1.install Dir["man/*.1"]

      prefix.install_metafiles
    end
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
