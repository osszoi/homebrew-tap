class Reap < Formula
  desc "Code health scanner for Java — git hotspots, complexity, duplicates, dead code, dependencies"
  homepage "https://github.com/osszoi/reap"
  version "0.6.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/osszoi/reap/releases/download/v0.6.1/reap-aarch64-apple-darwin.tar.xz"
    sha256 "e4ec00f93a977ea76ca9b1aa63b9e4c882562735e579cef71ecfc224df060b9c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/reap/releases/download/v0.6.1/reap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3169804900cc08d3e30249892e37eb5e53b3a3a152fb08ed0a5ce87018722186"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/reap/releases/download/v0.6.1/reap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c2b5871476a2e0998f78ef66be7025de90cec3ca2286679e00445b908e49430b"
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
    bin.install "reap" if OS.mac? && Hardware::CPU.arm?
    bin.install "reap" if OS.linux? && Hardware::CPU.arm?
    bin.install "reap" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
