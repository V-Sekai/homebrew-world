# Documentation: https://docs.brew.sh/Cask-Cookbook
#                https://docs.brew.sh/Adding-Software-to-Homebrew#cask-stanzas
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
cask "vsekai-godot" do
  version "latest.v-sekai-editor-258"
  sha256 "d16dc2b57f363a7db552f20502714c30b226773446d6014a6cc01a568bfa7762"

  url "https://github.com/V-Sekai/world-godot/releases/download/#{version}/v-sekai-godot-macos.zip"
  name "vsekai-godot"
  desc ""
  homepage ""

  # Documentation: https://docs.brew.sh/Brew-Livecheck
  livecheck do
    url "https://github.com/V-Sekai/world-godot/releases"
    strategy :github_latest
  end

  depends_on macos: ""

  app ""

  # Documentation: https://docs.brew.sh/Cask-Cookbook#stanza-zap
  zap trash: ""
end
