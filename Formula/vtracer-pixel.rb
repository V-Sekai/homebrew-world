class VtracerPixel < Formula
  desc "Raster to vector graphics converter (V-Sekai pixel fork)"
  homepage "https://github.com/V-Sekai-fire/vtracer-pixel"
  version "0.6.12"

  on_macos do
    url "https://github.com/V-Sekai-fire/vtracer-pixel/releases/download/v0.6.12/vtracer-pixel-macos.zip"
    sha256 "9ff223e9474cd81b16d828d9f88ed631cf52c31d2037f0829c61be753a755392"
  end

  on_linux do
    url "https://github.com/V-Sekai-fire/vtracer-pixel/releases/download/v0.6.12/vtracer-pixel-linux.zip"
    sha256 "fdd7c8b15b56b27ee332d633679f380227fb8223606db67ae7d60c6fff7c09f2"
  end

  def install
    bin.install "vtracer-pixel"
  end

  test do
    system "#{bin}/vtracer-pixel", "--version"
  end
end
