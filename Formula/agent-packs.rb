class AgentPacks < Formula
  desc "Homebrew for AI agent skills and plugins - install curated packs into Claude Code, Cursor, Codex, and more"
  homepage "https://github.com/agent-packs/cli"
  version "0.6.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/agent-packs/cli/releases/download/v0.6.0/agent-packs_darwin_arm64.tar.gz"
      sha256 "7e7c2e3c7040a904f387b3333f2a1fdf7fae6308b73cdb5cb08142763435c1f4"
    else
      url "https://github.com/agent-packs/cli/releases/download/v0.6.0/agent-packs_darwin_amd64.tar.gz"
      sha256 "6791d556e5f9868c439c7cbfb05acf23d695274a10ae18d54fc66053f43b659f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/agent-packs/cli/releases/download/v0.6.0/agent-packs_linux_arm64.tar.gz"
      sha256 "8296f1c010810da3c6fd1bf2fd910203e3946a40af41c18104fd5ca132d9c274"
    else
      url "https://github.com/agent-packs/cli/releases/download/v0.6.0/agent-packs_linux_amd64.tar.gz"
      sha256 "857f96c0782ee5d1d2d33cb8930e981f086d234906718580ec56b2d76b931c37"
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
    assert_match version.to_s, shell_output("#{bin}/agent-packs version")
  end
end
