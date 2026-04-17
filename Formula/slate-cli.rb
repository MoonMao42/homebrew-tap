class SlateCli < Formula
  desc "Cross-platform terminal beautification kit for macOS and Linux"
  homepage "https://github.com/MoonMao42/slate"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MoonMao42/slate/releases/download/v0.1.1/slate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b27251a890a594b20b5f5234d1d9af4668e2d598b7d13b8e2b72f04bbb34e511"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MoonMao42/slate/releases/download/v0.1.1/slate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "edd551a92fb403f2efddd383028493b1210845c891141b26935f0ec08b193371"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MoonMao42/slate/releases/download/v0.1.1/slate-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b14bb1638cc7ab75df98f1ab3b63e9d663353d80d6236c6b700617d43cd4341b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MoonMao42/slate/releases/download/v0.1.1/slate-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7d2d5f3c1005aa71c7af89cf8bf7617afb8b8d7389c2ccc68d29126589c80e54"
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
