class Vtracer < Formula
  desc "Raster to vector graphics converter"
  homepage "https://github.com/visioncortex/vtracer"
  version "0.6.4"

  on_macos do
    on_intel do
      url "https://github.com/visioncortex/vtracer/releases/download/0.6.4/vtracer-x86_64-apple-darwin.tar.gz"
      sha256 "f0d755292c2602d772d63d658a3498b23eca8b5620d4b92a991bd035d5abed16"
    end
    on_arm do
      url "https://github.com/visioncortex/vtracer/releases/download/0.6.4/vtracer-aarch64-apple-darwin.tar.gz"
      sha256 "4a597fd2df8b961d60620df40a7436109427d86e5c028758e6e8796b02d3d996"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/visioncortex/vtracer/releases/download/0.6.4/vtracer-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9290ba0c90e224d6d212836dff5491407c1718bcb72f80b2b5a4a01816df5e40"
    end
    on_arm do
      url "https://github.com/visioncortex/vtracer/releases/download/0.6.4/vtracer-aarch64-unknown-linux-musl.tar.gz"
      sha256 "cbd05ad4f491d12dd139ada61485ca1d24db9f981cbe1658632a083cd0ac1a71"
    end
  end

  def install
    bin.install "vtracer"
  end

  test do
    system "#{bin}/vtracer", "--version"
  end
end
