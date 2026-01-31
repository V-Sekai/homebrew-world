cask "tool-model-explorer" do
  version "0.4.1-nightly-4ed943f"
  sha256 "abcb796bcac9b5fd89ee24f237fcf843bfe34b7f11216bf93b92902505fc5459"

  release_tag = "v0.4.1-nightly-2026-01-31T143152-4ed943f_editor-a1ee3d1"
  url "https://github.com/V-Sekai/TOOL_model_explorer/releases/download/#{release_tag}/TOOL_model_explorer_v0.4.1-4ed943f_editor-a1ee3d1_Mac.zip"
  name "TOOL Model Explorer"
  desc "V-Sekai Model Explorer"
  homepage "https://github.com/V-Sekai/TOOL_model_explorer"

  app "ModelExplorer.app", target: "ModelExplorer.app"
end
