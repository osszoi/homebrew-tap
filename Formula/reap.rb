class Reap < Formula
  desc "Code health scanner for Java — git hotspots, complexity, duplicates, dead code, dependencies"
  homepage "https://github.com/osszoi/reap"
  version "0.6.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/osszoi/reap/releases/download/v0.6.0/reap-aarch64-apple-darwin.tar.xz"
    sha256 "6c39bff36eb017401eb71b27bec0cdb7b1c8b2089ee81da54b98c53d2c6194ea"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/reap/releases/download/v0.6.0/reap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7788e38c63691233104021fe1f1e3a165b9f1f0dab41ae5d509edc6ca633a535"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/reap/releases/download/v0.6.0/reap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "976513fa35285b84d72e67db04738b48f6e9d2b2486d00ab0d777e44b71ed00e"
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
