cask "vsekai-godot-dev" do
  version "latest.v-sekai-editor-269"
  sha256 "f2ad16f1e63902d769bb6ac110d8dba9d131937610944aad393f1860d9e1e0c9"

  url "https://github.com/V-Sekai/world-godot/releases/download/#{version}/v-sekai-godot-macos.zip"

  name "vsekai-godot"
  desc "V-Sekai Godot Editor"
  homepage "https://github.com/V-Sekai/world-godot"

  app "v-sekai-godot-macos/godot_macos_editor_double.app", target: "vsekai_godot.app"
  zap trash: ""
end
