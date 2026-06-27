class SlateCli < Formula
  desc "Cross-platform terminal beautification kit for macOS and Linux"
  homepage "https://github.com/MoonMao42/slate"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MoonMao42/slate/releases/download/v0.4.0/slate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "cedf8aafb1c976deec03d4e1912f13d209146c61b12e09edf835d7a36b0b0939"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MoonMao42/slate/releases/download/v0.4.0/slate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b35ff8d1bab0c701daea7ba04aa3ba7471d08946e86b6577217072d64bc4b8ea"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MoonMao42/slate/releases/download/v0.4.0/slate-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a1feff537e8ccd536399eecb78b293b16e25840fe986757887a2123f3968762a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MoonMao42/slate/releases/download/v0.4.0/slate-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "72a809fe7831910f3f3814e3a9020993e9bd05fdc627646d7fb52475c8947599"
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
