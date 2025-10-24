class VsekaiGodot < Formula
  desc "V-Sekai Godot Editor"
  homepage "https://github.com/V-Sekai/world-godot"
  version "latest.v-sekai-editor-258"

  # macOS specific details
  on_macos do
    url "https://github.com/V-Sekai/world-godot/releases/download/#{version}/v-sekai-godot-macos.zip"
    sha256 "d16dc2b57f363a7db552f20502714c30b226773446d6014a6cc01a568bfa7762"
  end

  # Linux specific details
  on_linux do
    url "https://github.com/V-Sekai/world-godot/releases/download/#{version}/v-sekai-godot-linuxbsd.zip"
    sha256 "c4a57cb50e001976572e45ee839d26fd5a4caeef94e86b98a96582700e96761d"
  end

  license "MIT"

  def install
    if OS.mac?
      # For macOS, extract the zip and then symlink the main executable from within the .app bundle.
      system "unzip", "-q", cached_download_path, "-d", prefix

      # The executable is found at: vsekai-godot-macos/godot_macos_editor_double.app/Contents/MacOS/Godot
      # We symlink this to the main bin directory as 'vsekai-godot'
      bin.install_symlink prefix/"vsekai-godot-macos/godot_macos_editor_double.app/Contents/MacOS/Godot" => "vsekai-godot"
    elsif OS.linux?
      # For Linux, extract the zip and link the main executable.
      system "unzip", "-q", cached_download_path, "-d", prefix

      # Assume the executable is named 'godot' in a 'bin' subdirectory or at the root of the extracted archive.
      executable_path = Dir[prefix/"bin/godot"].first || Dir[prefix/"godot"].first

      if executable_path
        bin.install_symlink executable_path => "vsekai-godot"
      else
        raise "Could not find the Linux executable in the archive. Please inspect the zip contents."
      end
    end
  end

  test do
    # Test that the binary runs and outputs version. Assumes it's linked as 'vsekai-godot'.
    # This test needs to work for both macOS and Linux executables.
    if OS.mac?
      assert_match "usage:", shell_output("#{bin}/vsekai-godot --help")
    elsif OS.linux?
      # Assume a binary named 'vsekai-godot' is available and executable.
      assert_match "usage:", shell_output("#{bin}/vsekai-godot --help")
    end
  end
end
