class Desync < Formula
  desc "Alternative casync implementation"
  homepage "https://github.com/folbricht/desync"
  url "https://github.com/folbricht/desync.git",
      tag:      "v0.9.6",
      revision: "009540f65c1d26ae3c7dab40e45df0dbc2a71011"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    system "go", "build", "-o", bin/"desync", *std_go_args(ldflags: "-s -w"), "./cmd/desync"
  end

  test do
    system "#{bin}/desync", "--version"
  end
end
