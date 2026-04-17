class SlateCli < Formula
  desc "Cross-platform terminal beautification kit for macOS and Linux"
  homepage "https://github.com/MoonMao42/slate"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MoonMao42/slate/releases/download/v0.1.0/slate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "27aa3cc222058c2c9123d59e4f07d2f1ddd9eae2add490e9770cd2be5b4d6e57"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MoonMao42/slate/releases/download/v0.1.0/slate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0cd123549c8975db18b30f62dfb1729d1a70662898f0486ce86ff286c7074cfb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MoonMao42/slate/releases/download/v0.1.0/slate-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "03ef307551fc9ee1805a7a6aa9cc9f760817778c18ffb5355314a6763c7448e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MoonMao42/slate/releases/download/v0.1.0/slate-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f8a0de0532977d3e2073d8eeb56dec487dfc07e817bfce7558a85d1b460a1ae3"
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
