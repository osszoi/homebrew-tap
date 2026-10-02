class Reap < Formula
  desc "Code health scanner for Java — git hotspots, complexity, duplicates, dead code, dependencies"
  homepage "https://github.com/osszoi/reap"
  version "0.7.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/osszoi/reap/releases/download/v0.7.0/reap-aarch64-apple-darwin.tar.xz"
    sha256 "50c7881d60831839724943b71116a75c3d89f258ebea8179994477fdce09cb8c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/reap/releases/download/v0.7.0/reap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0271ab68307120b4849876c5a7671055962cfbf1f69e564af4341318a80c72e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/reap/releases/download/v0.7.0/reap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cda0a60f48fbd431f3a9d86bd2fe70845b184e232f347fba54fd08f74a9823f7"
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
