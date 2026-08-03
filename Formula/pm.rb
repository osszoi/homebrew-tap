class Pm < Formula
  desc "Process manager with a TUI — runs your commands through your real shell, keeps them alive, starts them at login"
  homepage "https://github.com/osszoi/process-manager"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.0/pm-aarch64-apple-darwin.tar.xz"
      sha256 "6e0b2c91b63f61d77304a8498ac4c29a95004a74bc1533dcef3771633588550c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.0/pm-x86_64-apple-darwin.tar.xz"
      sha256 "38411ae6f0b030cb8a0d83ce66f452926fbb8a378aa59af240c21714e8fde008"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.0/pm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c27ffbd44f27d9ada18af04f19f1cfa493b58b21ed108029cdd21a305cf64f6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/osszoi/process-manager/releases/download/v0.1.0/pm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b95b69b2d43313d9324841e8d3790ef7df7ee861b33c262223ea3937d09c2cc2"
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
