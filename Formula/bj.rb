class Bj < Formula
  desc "The bj application"
  homepage "https://github.com/bricolaje-app/homebrew-tap"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bricolaje-app/homebrew-tap/releases/download/bj-v0.1.0/bj-aarch64-apple-darwin.tar.xz"
      sha256 "376e0a93f1442e9c28e85966bfc5981a6841db4096ebec843e24ccec025d8840"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bricolaje-app/homebrew-tap/releases/download/bj-v0.1.0/bj-x86_64-apple-darwin.tar.xz"
      sha256 "6d022f1ee428268362c076ef45080030fc179282efc4d74ff048d25df6e85324"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    bin.install "bj" if OS.mac? && Hardware::CPU.arm?
    bin.install "bj" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
