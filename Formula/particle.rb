class Particle < Formula
  desc "The command-line interface for Particle — podcast intelligence from your terminal"
  homepage "https://particle.pro"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.1.1/particle-cli-aarch64-apple-darwin.tar.xz"
      sha256 "55664aef21ba42811d007c3b1ac283c1309409d36c2042d37fb6c9776233be14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.1.1/particle-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0cda5a974152704ae9852dc56042a01136b2c1b35be9f94b6d539fd882cd8b71"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.1.1/particle-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "51a0873d0b2111a8711fe322d952e899bed3db830682a8e06670b99ee4954b1f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.1.1/particle-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "45aeb1d6822acc2d81d4661066a343fa655291f21b0a032c5740c5926db23226"
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

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
