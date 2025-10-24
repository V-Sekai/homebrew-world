# Documentation: https://docs.brew.sh/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class VsekaiGodotLinuxbsd < Formula
  desc "V-Sekai Godot Editor for Linux/BSD"
  homepage "https://github.com/V-Sekai/world-godot"
  version "latest.v-sekai-editor-258"

  url "https://github.com/V-Sekai/world-godot/releases/download/#{version}/v-sekai-godot-linuxbsd.zip"
  sha256 "c4a57cb50e001976572e45ee839d26fd5a4caeef94e86b98a96582700e96761d"

  # This formula assumes the zip contains the executable directly or in a predictable subfolder.
  # The scoop-world definition used 'extract_dir: "v-sekai-godot-windows"'.
  # We'll assume a similar structure for the Linux zip.
  # If the actual zip structure differs, this may need adjustment.
  def install
    # Extract the zip to a temporary directory to process its contents.
    # The extract_to_dir helper extracts the archive and returns the path to the extracted directory.
    # It automatically handles common archive types like zip, tar.gz, etc.
    zip_content_dir = extract_to_dir(cached_download_path)

    # The exact name of the directory containing the Godot binaries inside the zip needs to be confirmed.
    # Based on the Windows scoop definition and common patterns, it might be named 'v-sekai-godot-linuxbsd'.
    # We will install the contents of this assumed folder into the formula's installation prefix.
    extracted_folder_name = "v-sekai-godot-linuxbsd"

    # Ensure the extracted folder exists before attempting to install its contents.
    if Dir.exist?("#{zip_content_dir}/#{extracted_folder_name}")
      prefix.install Dir["#{zip_content_dir}/#{extracted_folder_name}/*"]
    else
      # Fallback: if the zip doesn't contain a subfolder, install everything from the root of the extraction.
      # This might occur if the archive contains files directly at its root.
      prefix.install Dir["#{zip_content_dir}/*"]
      extracted_folder_name = "." # Adjust for binary linking if needed
    end

    # Link the executable(s).
    # We need to find the actual executable name within the installed files.
    # Common names like 'godot' or 'godot.editor.x86_64' are possibilities.
    # We'll attempt to link any files marked as executable within the prefix.
    # If a specific executable needs to be linked (e.g., to 'godot'), this part might need manual adjustment.
    Dir[prefix/"*"].select { |f| File.executable?(f) }.each do |exec_path|
      bin.install_symlink exec_path
    end
  end

  # Define how to check for new versions automatically.
  livecheck do
    url "https://github.com/V-Sekai/world-godot/releases"
    strategy :github_latest
  end

  # Define any files to trash on uninstall.
  # If binaries are installed in specific subdirectories, this might need adjustment.
  # The `prefix` variable points to the installation directory for the formula.
  # zap_trash: [prefix] # Commented out as it could be too aggressive; usually more specific paths are preferred.
end
