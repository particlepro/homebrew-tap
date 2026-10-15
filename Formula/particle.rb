class Particle < Formula
  desc "The command-line interface for Particle — podcast intelligence from your terminal"
  homepage "https://particle.pro"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.3.0/particle-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b68e40b73b2f359b873fde308a43b4b75e7b26288b732eb85cfef759775720f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.3.0/particle-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9d06816f203084cf712306bec6f5e752494e79abcf1e8cb49fb1d3b69b7a57dd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.3.0/particle-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3e64a221bad2f31b774e15e6d556a823929edb33a7477bd6e1f1d11f243492fe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.3.0/particle-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2b84121076e03d94253d61f603d273d5c070c6d61295c5aa0d7f644102e1cd93"
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
