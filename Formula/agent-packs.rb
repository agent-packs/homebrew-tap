class AgentPacks < Formula
  desc "Homebrew for AI agent skills and plugins - install curated packs into Claude Code, Cursor, Codex, and more"
  homepage "https://github.com/agent-packs/cli"
  version "0.9.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/agent-packs/cli/releases/download/v0.9.0/agent-packs_darwin_arm64.tar.gz"
      sha256 "b041d47761e6e225726b87d0eee9e69fb7998f04d761c285cebea7dd200cc638"
    else
      url "https://github.com/agent-packs/cli/releases/download/v0.9.0/agent-packs_darwin_amd64.tar.gz"
      sha256 "3fdfb6b085ceaac44f8151e212c3e279b4b60f5f97e57e7a1eb3c48ba8629bed"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/agent-packs/cli/releases/download/v0.9.0/agent-packs_linux_arm64.tar.gz"
      sha256 "fb3a83e7ffad8245a30ffafdb67b876cb940a69bcf21a77077a57def7def274a"
    else
      url "https://github.com/agent-packs/cli/releases/download/v0.9.0/agent-packs_linux_amd64.tar.gz"
      sha256 "ad10c96dc9b54721cfdb9aa1f899f30c075f3390d533604cc27ab3a522f8da9d"
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
