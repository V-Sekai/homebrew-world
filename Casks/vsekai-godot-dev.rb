cask "vsekai-godot-dev" do
  version "latest.v-sekai-editor-258"
  sha256 "d16dc2b57f363a7db552f20502714c30b226773446d6014a6cc01a568bfa7762"

  url "https://github.com/V-Sekai/world-godot/releases/download/#{version}/v-sekai-godot-macos.zip"

  name "vsekai-godot"
  desc "V-Sekai Godot Editor"
  homepage "https://github.com/V-Sekai/world-godot"

  app "v-sekai-godot-macos/godot_macos_editor_double.app", target: "vsekai_godot.app"
  zap trash: ""
end
