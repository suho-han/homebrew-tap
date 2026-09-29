class Oct < Formula
  desc "One binary that organizes your AI coding CLIs — update, quota watch, maintenance"
  homepage "https://github.com/suho-han/one-click-ai-tools"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.6/one-click-ai-tools_darwin_arm64.tar.gz"
      sha256 "ab5c877b6b50169793a998ee44c8296bb2740e37d6863ae55687d91984fa6e11"
    else
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.6/one-click-ai-tools_darwin_amd64.tar.gz"
      sha256 "4c23741c8a0ab1f4e7ba37f95dfa2de2dcbe75c5d5af3bee5cb78d29b4233f13"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.6/one-click-ai-tools_linux_arm64.tar.gz"
      sha256 "d3d09dd1496c66b33eba37812b4a92c0f595829f40878e73198b94fa38f656c5"
    else
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.6/one-click-ai-tools_linux_amd64.tar.gz"
      sha256 "4b4b4da3f6607a854a73fd2e7342589c0fb96123d4d89f626d02d8002545ec4a"
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
