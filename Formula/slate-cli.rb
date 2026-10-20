class SlateCli < Formula
  desc "Cross-platform terminal beautification kit for macOS and Linux"
  homepage "https://github.com/MoonMao42/slate"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MoonMao42/slate/releases/download/v0.6.0/slate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "18e0530c4b053108357a214b03e490c467fa017ec1e7bffc06b908925e6fa386"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MoonMao42/slate/releases/download/v0.6.0/slate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "386c3b62bec49eaf7bf968a0bbffc7b1f248dd00d4a0c362d1ff97c637fd3d7e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MoonMao42/slate/releases/download/v0.6.0/slate-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9f76ed5883c4bebfd8f83cb4d87cd915d21dc00069ce57df458959cea5194fce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MoonMao42/slate/releases/download/v0.6.0/slate-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d7a875b8438413df7795ce7cbcfa4614cd9736760603301f02c06e609bb81c5f"
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
