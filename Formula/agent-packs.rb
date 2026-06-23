class AgentPacks < Formula
  desc "Homebrew for AI agent skills and plugins - install curated packs into Claude Code, Cursor, Codex, and more"
  homepage "https://github.com/agent-packs/cli"
  version "0.8.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/agent-packs/cli/releases/download/v0.8.0/agent-packs_darwin_arm64.tar.gz"
      sha256 "aab9b19ab1c00a757196153e1627ff11fa8f8ca73e3128d5165491f9e398aa2f"
    else
      url "https://github.com/agent-packs/cli/releases/download/v0.8.0/agent-packs_darwin_amd64.tar.gz"
      sha256 "aac8743af32dbd8afa80883dd952284753323f5566eab579a51beb3125b053b3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/agent-packs/cli/releases/download/v0.8.0/agent-packs_linux_arm64.tar.gz"
      sha256 "ac3d114687778655bb15375052793637119cc2993a592b1c97b347348b1ddba3"
    else
      url "https://github.com/agent-packs/cli/releases/download/v0.8.0/agent-packs_linux_amd64.tar.gz"
      sha256 "beb3b977f7213526a1effbc7b20621ac6dfe9a1965e2e460be3c889f593065f8"
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
