class Pm < Formula
  desc "Process manager with a TUI — runs your commands through your real shell, keeps them alive, starts them at login"
  homepage "https://github.com/osszoi/process-manager"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.2/pm-aarch64-apple-darwin.tar.xz"
      sha256 "8c67b32355c70cb518e629cff11b893c7cb0e0aaf1675c8e1cb528fbdd37fe42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.2/pm-x86_64-apple-darwin.tar.xz"
      sha256 "535c5e9964cf3a29156e26a6b8afc13d0dd9289de60e6e7138a1d428367f4d19"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.2/pm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6435936519c3d1f81a9a74893168df0f9a203db6346afe8de85a9b585d1f5a96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.2/pm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ef3aea127446a2347b434b45e54ad505a92cb511c937891b9f9e67dbfd1d9b5a"
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
