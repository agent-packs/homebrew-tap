#!/usr/bin/env python3
"""Sync Formula/agent-packs.rb from the latest agent-packs CLI release."""

from __future__ import annotations

import json
import os
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path


REPO = "agent-packs/cli"
API_ROOT = "https://api.github.com"
FORMULA = Path("Formula/agent-packs.rb")
REQUIRED_ASSETS = {
    "agent-packs_darwin_arm64.tar.gz": "darwin_arm64",
    "agent-packs_darwin_amd64.tar.gz": "darwin_amd64",
    "agent-packs_linux_arm64.tar.gz": "linux_arm64",
    "agent-packs_linux_amd64.tar.gz": "linux_amd64",
}


def request(url: str) -> bytes:
    headers = {
        "Accept": "application/vnd.github+json",
        "User-Agent": "agent-packs-homebrew-sync",
    }
    token = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")
    if token:
        headers["Authorization"] = f"Bearer {token}"
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=30) as response:
            return response.read()
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        raise SystemExit(f"request failed: {url}: HTTP {exc.code}: {body}") from exc


def latest_release() -> dict:
    return json.loads(request(f"{API_ROOT}/repos/{REPO}/releases/latest"))


def parse_checksums(text: str) -> dict[str, str]:
    checksums: dict[str, str] = {}
    for line in text.splitlines():
        parts = line.split()
        if len(parts) >= 2:
            checksums[Path(parts[1]).name] = parts[0]
    return checksums


def asset_map(release: dict) -> dict[str, dict]:
    return {asset["name"]: asset for asset in release.get("assets", [])}


def release_checksums(release: dict) -> dict[str, str]:
    assets = asset_map(release)
    if "checksums.txt" not in assets:
        raise SystemExit("latest release is missing checksums.txt")
    checksum_url = assets["checksums.txt"]["browser_download_url"]
    checksums = parse_checksums(request(checksum_url).decode("utf-8"))
    missing = sorted(name for name in REQUIRED_ASSETS if name not in checksums)
    if missing:
        raise SystemExit(f"checksums.txt missing required assets: {', '.join(missing)}")
    return checksums


def current_version() -> str | None:
    if not FORMULA.exists():
        return None
    match = re.search(r'^\s*version\s+"([^"]+)"', FORMULA.read_text(), re.MULTILINE)
    return match.group(1) if match else None


def formula_text(version: str, checksums: dict[str, str]) -> str:
    return f'''class AgentPacks < Formula
  desc "Homebrew for AI agent skills and plugins - install curated packs into Claude Code, Cursor, Codex, and more"
  homepage "https://github.com/agent-packs/cli"
  version "{version}"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/agent-packs/cli/releases/download/v{version}/agent-packs_darwin_arm64.tar.gz"
      sha256 "{checksums["agent-packs_darwin_arm64.tar.gz"]}"
    else
      url "https://github.com/agent-packs/cli/releases/download/v{version}/agent-packs_darwin_amd64.tar.gz"
      sha256 "{checksums["agent-packs_darwin_amd64.tar.gz"]}"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/agent-packs/cli/releases/download/v{version}/agent-packs_linux_arm64.tar.gz"
      sha256 "{checksums["agent-packs_linux_arm64.tar.gz"]}"
    else
      url "https://github.com/agent-packs/cli/releases/download/v{version}/agent-packs_linux_amd64.tar.gz"
      sha256 "{checksums["agent-packs_linux_amd64.tar.gz"]}"
    end
  end

  def install
    bin.install "agent-packs"
  end

  def caveats
    <<~EOS
      Get started:
        agent-packs search              # Browse the registry
        agent-packs install backend-engineer --agent claude
        agent-packs doctor              # Check your environment

      Shell completion (add to ~/.zshrc):
        eval "$(agent-packs completion zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{{bin}}/agent-packs version")
  end
end
'''


def github_output(name: str, value: str) -> None:
    output = os.environ.get("GITHUB_OUTPUT")
    if output:
        with open(output, "a", encoding="utf-8") as handle:
            handle.write(f"{name}={value}\n")


def main() -> int:
    release = latest_release()
    tag = release["tag_name"]
    if not tag.startswith("v"):
        raise SystemExit(f"latest release tag must start with v: {tag}")
    version = tag[1:]
    github_output("version", version)

    if current_version() == version:
        print(f"Formula already at agent-packs {version}.")
        github_output("changed", "false")
        return 0

    checksums = release_checksums(release)
    FORMULA.parent.mkdir(parents=True, exist_ok=True)
    FORMULA.write_text(formula_text(version, checksums), encoding="utf-8")
    print(f"Updated {FORMULA} to agent-packs {version}.")
    github_output("changed", "true")
    return 0


if __name__ == "__main__":
    sys.exit(main())
