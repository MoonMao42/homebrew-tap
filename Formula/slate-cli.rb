class SlateCli < Formula
  desc "Cross-platform terminal beautification kit for macOS and Linux"
  homepage "https://github.com/MoonMao42/slate"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MoonMao42/slate/releases/download/v0.2.0/slate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ed7c644c8f52ebe41b39772080ad69fabfb5836c9bb5a7afcaf70858710667f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MoonMao42/slate/releases/download/v0.2.0/slate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8a489a684aeea5cd80098b147613b56ba5657d95b58032581b17b71e774b4a5d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MoonMao42/slate/releases/download/v0.2.0/slate-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a38789f728703a8b0d19e3b12aee087ae5001b102332a2955b0e43e7614925fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MoonMao42/slate/releases/download/v0.2.0/slate-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4fc44fcce7d7570afb5d6eec3b5651a44e951254a87175589e64c742b2788057"
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
