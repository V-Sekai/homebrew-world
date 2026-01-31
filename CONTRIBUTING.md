# Contributing to V-Sekai Homebrew (and related packaging)

This document describes how we maintain casks and related package manifests for V-Sekai projects.

## Overview

- **homebrew-world**: Homebrew tap (macOS casks, and formulae where applicable).
- **scoop-world**: Scoop bucket (Windows). Many of the same apps are published there; when we cut a new release we often update both.

Our process: bump versions, point URLs at new release assets, and update hashes so installs verify correctly.

## Prerequisites

- [Git](https://git-scm.com/) and a clone of this repo (and of [scoop-world](https://github.com/V-Sekai/scoop-world) if you update Windows manifests).
- [GitHub CLI](https://cli.github.com/) (`gh`) — we use it to fetch release asset hashes without downloading files manually.

## Getting hashes from GitHub releases

Use `gh release view` so hashes come from GitHub’s digest instead of local downloads:

```bash
gh release view <TAG> --repo <ORG/REPO> --json assets
```

Each asset has a `digest` field like `sha256:<hex>`. Use the `<hex>` part for `sha256` in casks and `hash` in Scoop manifests.

Example (Godot editor):

```bash
gh release view latest.v-sekai-editor-279 --repo V-Sekai/world-godot --json assets
```

Example (single asset, e.g. model explorer):

```bash
gh release view v0.4.1-nightly-2026-01-31T143152-4ed943f_editor-a1ee3d1 --repo V-Sekai/TOOL_model_explorer --json assets
```

## Updating V-Sekai Godot Editor

When a new [world-godot](https://github.com/V-Sekai/world-godot) release is published (e.g. `latest.v-sekai-editor-279`):

1. **Fetch asset hashes** (see above). You need hashes for:
   - `v-sekai-godot-macos.zip` (Homebrew)
   - `v-sekai-godot-windows.zip` (Scoop)
   - `v-sekai-godot-templates.zip.001`
   - `v-sekai-godot-templates-symbols.zip.001` and `.002`

2. **Homebrew** (`Casks/v-sekai-godot.rb`, `Casks/v-sekai-godot-dev.rb`):
   - Set `version` (e.g. `latest.v-sekai-editor-279.3`) and `release_version` (e.g. `latest.v-sekai-editor-279`).
   - Set top-level `sha256` to the Mac zip digest.
   - Set `templates_sha256`, `symbols_sha256_001`, `symbols_sha256_002` in the postflight block.

3. **Scoop** (`v-sekai-godot.json` in scoop-world):
   - Set `version` and the download `url` to the new release.
   - Set `hash` to the Windows zip digest.
   - In the installer script, set `$release_version` and the three template/symbols SHA256 variables.

4. **Version increments**: When we re-release or do metadata-only bumps we increment the patch (e.g. 279.2 → 279.3) in all of the above so package managers see an update.

## Cask naming (Homebrew)

The cask **token** (the string in `cask "..."`) must match the **filename** (without `.rb`).

- File `v-sekai-godot.rb` → `cask "v-sekai-godot"`.
- File `tool-model-explorer.rb` → `cask "tool-model-explorer"`.

If they differ, `brew install` will report a definition error. Install command is then `brew install --cask <token>` (e.g. `brew install --cask v-sekai-godot`).

## Adding or updating another app (e.g. TOOL Model Explorer)

1. **Scoop** (scoop-world): Edit or add `<app>.json`. Set `version`, `url`, `hash` (from `gh release view … --json assets`), and `bin` to the correct executable name.

2. **Homebrew** (this repo): Add or edit `Casks/<token>.rb`. Use the same version and Mac asset URL; set `sha256` from the Mac asset digest.

3. **App path**: For a new Mac cask, confirm the zip layout so the `app` stanza is correct:
   ```bash
   curl -sL "<url-to-mac.zip>" -o /tmp/app.zip && unzip -l /tmp/app.zip
   ```
   Point `app` at the actual `.app` path (e.g. `ModelExplorer.app`), and use `target` if you want a different name in `/Applications`.

See also: [Update Scoop Manifest Workflow](https://github.com/V-Sekai/scoop-world/blob/main/.clinerules/workflows/update-scoop-manifest.md) in the scoop-world repo for manifest structure and optional PowerShell hash steps.

## Commits

- One logical change per commit (e.g. “Update v-sekai-godot to 279” or “Add tool-model-explorer cask”).
- Keep version-bump commits separate from “rename casks” or “fix app path” when it makes the history clearer.

## Summary

| Task              | Homebrew (this repo)     | Scoop (scoop-world)        |
|-------------------|--------------------------|----------------------------|
| Get hashes        | `gh release view … --json assets` | Same                       |
| Update Godot      | Both casks + postflight hashes     | Manifest + installer script hashes |
| New/updated app   | New/updated cask, verify zip with `unzip -l` | New/updated JSON manifest  |
| Cask token        | Must match `.rb` filename | N/A                        |
