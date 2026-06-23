class AgentPacks < Formula
  desc "Homebrew for AI agent skills and plugins - install curated packs into Claude Code, Cursor, Codex, and more"
  homepage "https://github.com/agent-packs/cli"
  version "0.7.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/agent-packs/cli/releases/download/v0.7.0/agent-packs_darwin_arm64.tar.gz"
      sha256 "12e4a99c005316bb5c2c2fb1491cfea9add1ee486af6551161c0819e8f6ab69d"
    else
      url "https://github.com/agent-packs/cli/releases/download/v0.7.0/agent-packs_darwin_amd64.tar.gz"
      sha256 "b18e9b218c0b244dc8c50b9f081aaaf645d45f2d7671bed3dad431cd3e7c8960"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/agent-packs/cli/releases/download/v0.7.0/agent-packs_linux_arm64.tar.gz"
      sha256 "b38a8c2bc6ac779d5eacb5034043ccef736cae6bc0ece1708d3c233d5a533bb1"
    else
      url "https://github.com/agent-packs/cli/releases/download/v0.7.0/agent-packs_linux_amd64.tar.gz"
      sha256 "d5d98c22f48f18bca8ae1bda43bc8a0b237e8047831a780406f4211bb124aef9"
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
