class Oct < Formula
  desc "One binary that organizes your AI coding CLIs — update, quota watch, maintenance"
  homepage "https://github.com/suho-han/one-click-ai-tools"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.6/one-click-ai-tools_darwin_arm64.tar.gz"
      sha256 "f3c02ec38ef58f203059e8f5739c06901fa1513aeb818cf8c87b0bb9ec7f15f0"
    else
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.6/one-click-ai-tools_darwin_amd64.tar.gz"
      sha256 "a3a5744f0546695b5bf3a075bd136f7d4db730619a94e43f0fda770b8f9c7e2c"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.6/one-click-ai-tools_linux_arm64.tar.gz"
      sha256 "6a7ac41947838c0eafee396223d4fcd097acb5557ac32055be2aa34da0868480"
    else
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.6/one-click-ai-tools_linux_amd64.tar.gz"
      sha256 "70b4ca17c152fab3477b6c5c1f3d99691e523585d10cd029b38a1bc6136619ed"
    end
  end

  def install
    bin.install "oct"
  end

  def caveats
    <<~EOS
      oct is also distributed via the install.sh channel, which installs to
      ~/.local/bin/oct. If both are installed, `which oct` decides which one
      runs. Keep only one if that matters to you.
    EOS
  end

  test do
    assert_match "oct version #{version}", shell_output("#{bin}/oct --version")
  end
end
