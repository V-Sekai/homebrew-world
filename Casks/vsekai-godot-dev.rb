cask "vsekai-godot-dev" do
  version "latest.v-sekai-editor-279.1"
  sha256 "ae73279fbf4dc3e55ebc5b03d8a4d5106924bbed88213ed284f6e34f397bc7dd"

  release_version = "latest.v-sekai-editor-279"
  url "https://github.com/V-Sekai/world-godot/releases/download/#{release_version}/v-sekai-godot-macos.zip"
  name "v-sekai-godot"
  desc "V-Sekai Godot Editor"
  homepage "https://github.com/V-Sekai/world-godot"

  app "v-sekai-godot-macos/godot_macos_editor_double.app", target: "v-sekai-godot.app"

  postflight do
    # Download and install export templates
    base_templates_dir = "#{Dir.home}/Library/Application Support/Godot/export_templates"
    FileUtils.mkdir_p base_templates_dir
    temp_dir = "#{base_templates_dir}/.tmp_#{release_version}"
    FileUtils.mkdir_p temp_dir

    # Download template files
    templates_url = "https://github.com/V-Sekai/world-godot/releases/download/#{release_version}/v-sekai-godot-templates.zip.001"
    templates_sha256 = "BFD7A64A0E1F477F642A90C111AF73425AB172F7C40ABE5109935B6C73904C79"
    templates_file_001 = "#{temp_dir}/v-sekai-godot-templates.zip.001"

    system_command "curl", args: ["-L", "-o", templates_file_001, templates_url]
    system_command "shasum", args: ["-a", "256", "-c", "-"], input: "#{templates_sha256}  #{templates_file_001}"

    # Download symbols template files (split zip)
    symbols_url_001 = "https://github.com/V-Sekai/world-godot/releases/download/#{release_version}/v-sekai-godot-templates-symbols.zip.001"
    symbols_sha256_001 = "E3FC838F3F8A8520EE2346FBE417F85F748699A0B38F062E4881FB2003BAE5CA"
    symbols_file_001 = "#{temp_dir}/v-sekai-godot-templates-symbols.zip.001"

    symbols_url_002 = "https://github.com/V-Sekai/world-godot/releases/download/#{release_version}/v-sekai-godot-templates-symbols.zip.002"
    symbols_sha256_002 = "5DF25D79D4C862E314C9E78101A2489F88DEEC733FE76C546EB2DDC151CBBD37"
    symbols_file_002 = "#{temp_dir}/v-sekai-godot-templates-symbols.zip.002"

    system_command "curl", args: ["-L", "-o", symbols_file_001, symbols_url_001]
    system_command "shasum", args: ["-a", "256", "-c", "-"], input: "#{symbols_sha256_001}  #{symbols_file_001}"

    system_command "curl", args: ["-L", "-o", symbols_file_002, symbols_url_002]
    system_command "shasum", args: ["-a", "256", "-c", "-"], input: "#{symbols_sha256_002}  #{symbols_file_002}"

    # Combine split zip files and extract templates
    template_version = nil
    Dir.chdir(temp_dir) do
      # Combine split zip files using cat (for split zips created with zip -s)
      templates_combined = "#{temp_dir}/v-sekai-godot-templates.zip"
      # Templates zip might be a single file or already complete
      FileUtils.cp templates_file_001, templates_combined

      symbols_combined = "#{temp_dir}/v-sekai-godot-templates-symbols.zip"
      # Combine split symbols zip files using cat
      system_command "sh", args: ["-c", "cat '#{symbols_file_001}' '#{symbols_file_002}' > '#{symbols_combined}'"]

      # Extract to temp location first
      extract_temp = "#{temp_dir}/extract"
      FileUtils.mkdir_p extract_temp
      system_command "unzip", args: ["-o", templates_combined, "-d", extract_temp]
      system_command "unzip", args: ["-o", symbols_combined, "-d", extract_temp]

      # Unzip the .tpz file if present (new format)
      tpz_file = Dir.glob("#{extract_temp}/**/*.tpz").first
      if tpz_file
        system_command "unzip", args: ["-o", tpz_file, "-d", extract_temp]
      end

      # Read version from version.txt in extracted templates
      version_file = Dir.glob("#{extract_temp}/**/version.txt").first
      template_version = nil
      if version_file && File.exist?(version_file)
        template_version = File.read(version_file).strip
        # Verify version.txt was read correctly and is not empty
        if template_version.blank?
          template_version = nil
        else
          # Use the version from version.txt (e.g., "4.6.beta.double")
          # This is the actual Godot version, not the release tag
        end
      end

      # If version.txt not found or invalid, we can't proceed without knowing the version
      raise "Could not determine template version from version.txt" if template_version.nil?

      templates_dir = "#{base_templates_dir}/#{template_version}"
      FileUtils.mkdir_p templates_dir

      # Move all files directly to templates_dir (flatten any subdirectories)
      Dir.glob("#{extract_temp}/**/*").each do |file|
        next if File.directory?(file)

        target_file = "#{templates_dir}/#{File.basename(file)}"
        FileUtils.mv file, target_file, force: true
      end

      # Verify version.txt exists in templates_dir
      version_txt_path = "#{templates_dir}/version.txt"
      unless File.exist?(version_txt_path)
        # If version.txt wasn't found, create it with the template_version
        File.write(version_txt_path, template_version)
      end
    end

    # Clean up temporary files
    FileUtils.rm_r(temp_dir)
  end

  zap trash: ""
end
