class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.41.0.tar.gz"
  sha256 "82f8c73a0e24d5a2ee598dcd8e2cf136a3a1492f2ea7136d51dfe31c8bc90230"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "078d778e06ae47f24732a55d0760757d0b6ad2fd57b8bfd4b6671afe44d38adb" => :catalina
    sha256 "f769ecd6e8843511c9d0039d0b0ee687a058e6e08de0968c650230cac282f6f2" => :mojave
    sha256 "de6c737880740ec45484ea44c1ca7814473e375a74dfb345c00fe8e26324ba29" => :high_sierra
    sha256 "9569f82c8859f48e604b33f2b0f4094280e855e7e44965cab318ba71f482f2c9" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    doctl_version = version.to_s.split(/\./)

    src = buildpath/"src/github.com/digitalocean/doctl"
    src.install buildpath.children
    src.cd do
      base_flag = "-X github.com/digitalocean/doctl"
      ldflags = %W[
        #{base_flag}.Major=#{doctl_version[0]}
        #{base_flag}.Minor=#{doctl_version[1]}
        #{base_flag}.Patch=#{doctl_version[2]}
        #{base_flag}.Label=release
      ].join(" ")
      system "go", "build", "-ldflags", ldflags, "-o", bin/"doctl", "github.com/digitalocean/doctl/cmd/doctl"
    end

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
