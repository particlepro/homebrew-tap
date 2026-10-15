class Particle < Formula
  desc "The command-line interface for Particle — podcast intelligence from your terminal"
  homepage "https://particle.pro"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.3.1/particle-cli-aarch64-apple-darwin.tar.xz"
      sha256 "726f38b137f4243fe640d2b8c12ce8f014b1088cae369e7a6d04cf2d956e47ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.3.1/particle-cli-x86_64-apple-darwin.tar.xz"
      sha256 "41b11fb42282e97be1dd570ab037bf318defef2a87762a9ca089c3477d64aaa7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.3.1/particle-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1f8d9b6632c11feaeaf93e4ed9aea30323dc40b12508794e7087676583e7788c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/particlepro/particle-cli/releases/download/v0.3.1/particle-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0387ac47ac77c2ed3c4b871a3abf90fe16ac6dd862346a47cf0fe18d1b1f74f7"
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
