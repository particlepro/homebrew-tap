class Particle < Formula
  desc "The command-line interface for Particle — podcast intelligence from your terminal"
  homepage "https://particle.pro"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.2.0/particle-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ad1b2dca8c0a8178934f2dc6577a477f41a6b06dc36101f14967d752d9698753"
    end
    if Hardware::CPU.intel?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.2.0/particle-cli-x86_64-apple-darwin.tar.xz"
      sha256 "05e415cd4a4e657b18a8434367f5fbf8129e57d8f4b82a116a8c09787fadf003"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.2.0/particle-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fc370d497a70e887449ebb2caa0a76d0aad839fb3f8339c360dcf9233b2587cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.2.0/particle-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7a614428b6b8d2f9ea306492e75aa40737ae9487ba62011f6d8bc58184f1fe0c"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "particle"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "particle"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "particle"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "particle"
    end

    install_binary_aliases!

    generate_completions_from_executable(bin/"particle", "completion")

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
