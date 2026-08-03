class Pm < Formula
  desc "Process manager with a TUI — runs your commands through your real shell, keeps them alive, starts them at login"
  homepage "https://github.com/osszoi/process-manager"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.4/pm-aarch64-apple-darwin.tar.xz"
      sha256 "ec48222715461419b0040e794b9777fe7237aad69b44286f2a7cb1fbb3c805dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.4/pm-x86_64-apple-darwin.tar.xz"
      sha256 "d5364e32c8724bec89cc4c3a0ce71eec815267868d4bebc7a3b1cba967834c17"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.4/pm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c288c5cfc6173a289f4ddad6b3f60322243639675b9b574b68aed1620a1532a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.4/pm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "516bca07c00c1e04cd90a3c2b420dda0f41579839eac4198d3fdbee84cbfd602"
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
