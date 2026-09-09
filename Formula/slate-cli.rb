class SlateCli < Formula
  desc "Cross-platform terminal beautification kit for macOS and Linux"
  homepage "https://github.com/MoonMao42/slate"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MoonMao42/slate/releases/download/v0.5.0/slate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b4af91215c9a1551507e51930dc453fdf0aa42ccd5bb2e9289e61889589c278e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MoonMao42/slate/releases/download/v0.5.0/slate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9320d7496dd6cb40d0ad24777cb7f5470f75bb157c85d10a9426353a060ad232"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MoonMao42/slate/releases/download/v0.5.0/slate-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "868f428580a5fd81b96504a8b71916e9f689811b4a70321b930bbc0a223cab71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MoonMao42/slate/releases/download/v0.5.0/slate-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fac8e84070666e9ba01cfcf6fb732519434d064c497d35f73c30464b9a72a86e"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "slate"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "slate"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "slate"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "slate"
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
