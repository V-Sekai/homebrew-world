cask "vsekai-godot" do
  version "latest.v-sekai-editor-269.2"
  sha256 "f2ad16f1e63902d769bb6ac110d8dba9d131937610944aad393f1860d9e1e0c9"

  release_version = "latest.v-sekai-editor-269"
  url "https://github.com/V-Sekai/world-godot/releases/download/#{release_version}/v-sekai-godot-macos.zip"

  name "vsekai-godot"
  desc "V-Sekai Godot Editor"
  homepage "https://github.com/V-Sekai/world-godot"

  app "v-sekai-godot-macos/godot_macos_editor_double.app", target: "vsekai_godot.app"

  postflight do
    # Download and install export templates
    base_templates_dir = "#{Dir.home}/Library/Application Support/Godot/export_templates"
    FileUtils.mkdir_p base_templates_dir
    temp_dir = "#{base_templates_dir}/.tmp_#{release_version}"
    FileUtils.mkdir_p temp_dir

    # Download template files
    templates_url = "https://github.com/V-Sekai/world-godot/releases/download/#{release_version}/v-sekai-godot-templates.zip.001"
    templates_sha256 = "7044f0035d6de1ae48a2b9ee9e764c7f72deef837612e9dfd35a8f4203be0084"
    templates_file_001 = "#{temp_dir}/v-sekai-godot-templates.zip.001"
    
    system_command "curl", args: ["-L", "-o", templates_file_001, templates_url]
    system_command "shasum", args: ["-a", "256", "-c", "-"], input: "#{templates_sha256}  #{templates_file_001}"

    # Download symbols template files (split zip)
    symbols_url_001 = "https://github.com/V-Sekai/world-godot/releases/download/#{release_version}/v-sekai-godot-templates-symbols.zip.001"
    symbols_sha256_001 = "48ce46e4b16b64d26730854e3a2ead23f9c8ac9e5948d3b7d5c86ad69bc8610a"
    symbols_file_001 = "#{temp_dir}/v-sekai-godot-templates-symbols.zip.001"
    
    symbols_url_002 = "https://github.com/V-Sekai/world-godot/releases/download/#{release_version}/v-sekai-godot-templates-symbols.zip.002"
    symbols_sha256_002 = "3e21fd591e2e9d8a07edcea6504b4f377f91aa212cb72955b3f2ac37454b75a9"
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
      
      # Read version from version.txt
      version_file = Dir.glob("#{extract_temp}/**/version.txt").first
      if version_file && File.exist?(version_file)
        template_version = File.read(version_file).strip
      end
      
      # Use version from templates, fallback to release version
      template_version ||= release_version
      templates_dir = "#{base_templates_dir}/#{template_version}"
      FileUtils.mkdir_p templates_dir
      
      # Move all files directly to templates_dir (flatten any subdirectories)
      Dir.glob("#{extract_temp}/**/*").each do |file|
        next if File.directory?(file)
        target_file = "#{templates_dir}/#{File.basename(file)}"
        FileUtils.mv file, target_file, force: true
      end
    end
    
    # Clean up temporary files
    FileUtils.rm_rf temp_dir
  end

  zap trash: ""
end
