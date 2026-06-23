class AgentPacks < Formula
  desc "Homebrew for AI agent skills and plugins — install curated packs into Claude Code, Cursor, Codex, and more"
  homepage "https://github.com/agent-packs/cli"
  version "0.5.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/agent-packs/cli/releases/download/v0.5.0/agent-packs_darwin_arm64.tar.gz"
      sha256 "b7b1545efbdbbb44b89f6366c7f19f5047ac64e7fe9b321b20ad954dce9b5bf0"
    else
      url "https://github.com/agent-packs/cli/releases/download/v0.5.0/agent-packs_darwin_amd64.tar.gz"
      sha256 "ad1fe239edb840abe4dad1eafe2e5d69a445179bc469405bff6bf923ac2b79cb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/agent-packs/cli/releases/download/v0.5.0/agent-packs_linux_arm64.tar.gz"
      sha256 "9ca566698b3d1752bf3bd7f17451b84ac5afeb61e998c9c4e56acb399900e97b"
    else
      url "https://github.com/agent-packs/cli/releases/download/v0.5.0/agent-packs_linux_amd64.tar.gz"
      sha256 "1f964ecee3fa37f795d4acb87d703e6f355430158e77ae7f823c347dcd448834"
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
