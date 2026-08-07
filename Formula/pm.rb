class Pm < Formula
  desc "Process manager with a TUI — runs your commands through your real shell, keeps them alive, starts them at login"
  homepage "https://github.com/osszoi/process-manager"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.6/pm-aarch64-apple-darwin.tar.xz"
      sha256 "5ce084416ab6743c1d46b7e9e05b9dcbec95e135eacd23c0bf53b271c55ce98e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.6/pm-x86_64-apple-darwin.tar.xz"
      sha256 "c5e2c0933cd808d0b551745303918c574e1e8cf204ff58ff592a4fab21adfdd2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.6/pm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ed826cbc0f0ecace3cd6be4864e4368505060897fdfd79ebe0430156c5f84c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.6/pm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "80c1668131306ce3b4e14f25b8decbe29eb386862c7650cdb528c4e50255ccb8"
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
