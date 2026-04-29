class SlateCli < Formula
  desc "Cross-platform terminal beautification kit for macOS and Linux"
  homepage "https://github.com/MoonMao42/slate"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MoonMao42/slate/releases/download/v0.3.1/slate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a3eec057124105ec38f4e7bc4d0b0ab1e649f14c98e4f6b2d5ab6cb0f449ffd0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MoonMao42/slate/releases/download/v0.3.1/slate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ce91d42412e6565f2a280ff39eea124defab8a5b3272ba81d3ba9578bf198825"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MoonMao42/slate/releases/download/v0.3.1/slate-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "41066afc43a1b1aeb4433838070bb7b031b3416e1b45df5280361d0c5d99995c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MoonMao42/slate/releases/download/v0.3.1/slate-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8186bcb7aa1e9de18b94e7827dd2681fb1a6cd068d50f1a8e32f416050400205"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "slate" if OS.mac? && Hardware::CPU.arm?
    bin.install "slate" if OS.mac? && Hardware::CPU.intel?
    bin.install "slate" if OS.linux? && Hardware::CPU.arm?
    bin.install "slate" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
