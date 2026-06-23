class AgentPacks < Formula
  desc "Install curated AI agent skills and plugins"
  homepage "https://github.com/agent-packs/cli"
  version "0.4.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/agent-packs/cli/releases/download/v0.4.0/agent-packs_darwin_arm64.tar.gz"
      sha256 "eb21a0d29fdf8e5c792145f1ca1942e6de46e46e5cfcc1b4321748761b36b58e"
    else
      url "https://github.com/agent-packs/cli/releases/download/v0.4.0/agent-packs_darwin_amd64.tar.gz"
      sha256 "b94eac3c42ca424132be07dfc8eceb33ca3db51d4c602b3983e066c61172acaa"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/agent-packs/cli/releases/download/v0.4.0/agent-packs_linux_arm64.tar.gz"
      sha256 "a6f6fb42279cc87c4a37e7c2b023aa96727dc57c78cecc528dd721b62a364bbd"
    else
      url "https://github.com/agent-packs/cli/releases/download/v0.4.0/agent-packs_linux_amd64.tar.gz"
      sha256 "b569cbe094fba7d88cd3047831cf6a14ed88a96da8d81d023188bc61d784b75a"
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
    assert_match version.to_s, shell_output("\#{bin}/agent-packs version")
  end
end
