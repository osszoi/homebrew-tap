class Pm < Formula
  desc "Process manager with a TUI — runs your commands through your real shell, keeps them alive, starts them at login"
  homepage "https://github.com/osszoi/process-manager"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.3/pm-aarch64-apple-darwin.tar.xz"
      sha256 "3551953bf5ef3e0f50f8267887aa505aa5863c7e5a30f76154c60db6ff763402"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.3/pm-x86_64-apple-darwin.tar.xz"
      sha256 "d1c58b67c03d24bd97e12ec8a05fc6e99f9950419ac537b24dcb0c1c0dd682f1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.3/pm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8567c9655f41bee8f4b910b0c73cad49f483ca58acaa1a1511cf7448a88993f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.3/pm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3c38310a23c1baa06dacef033f5468a3776ac68fe6a9f34b480c41a99d8fecb4"
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
    bin.install "pm" if OS.mac? && Hardware::CPU.arm?
    bin.install "pm" if OS.mac? && Hardware::CPU.intel?
    bin.install "pm" if OS.linux? && Hardware::CPU.arm?
    bin.install "pm" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
