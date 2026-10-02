class Reap < Formula
  desc "Code health scanner for Java — git hotspots, complexity, duplicates, dead code, dependencies"
  homepage "https://github.com/osszoi/reap"
  version "0.8.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/osszoi/reap/releases/download/v0.8.0/reap-aarch64-apple-darwin.tar.xz"
    sha256 "38b9a62acb68a075b0fdba77625c643386b29508cbae773a0474424b2c588eb0"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/reap/releases/download/v0.8.0/reap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "91df0b7affebba733204682108216d04624cd91090457a02a6d1f9f082af901d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/reap/releases/download/v0.8.0/reap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a2171d62070f0159451d4abdb7b4391667b350749881d91f53d4c6e41469c2f2"
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
