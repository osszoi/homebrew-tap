class Reap < Formula
  desc "Code health scanner for Java — git hotspots, complexity, duplicates, dead code, dependencies"
  homepage "https://github.com/osszoi/reap"
  version "0.8.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/osszoi/reap/releases/download/v0.8.1/reap-aarch64-apple-darwin.tar.xz"
    sha256 "6b21f79bbd25d02d6d60f08b33b5a419059794d6349bfbde657becd1edb9c9a8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/reap/releases/download/v0.8.1/reap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "999bfa278741dec0bd69c923a2eab7d55b89ea5f5d8898d89aa4f8c60c9785bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/reap/releases/download/v0.8.1/reap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3bd0ab4aee0269dad0fcca0075d4ea56207fced3e83bceee077b9c9c2fb08d2c"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
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
      bin.install "reap"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "reap"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "reap"
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
