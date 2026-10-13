class Oct < Formula
  desc "One binary that organizes your AI coding CLIs — update, quota watch, maintenance"
  homepage "https://github.com/suho-han/one-click-ai-tools"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.7/one-click-ai-tools_darwin_arm64.tar.gz"
      sha256 "d2ab426c055de151114acc9e9684928bd60808ae4b427da7a2814a818cbae701"
    else
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.7/one-click-ai-tools_darwin_amd64.tar.gz"
      sha256 "f225032aa552ed22cb1aec89bc3a374cb8cf556d224c5e04afccd1db1092884e"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.7/one-click-ai-tools_linux_arm64.tar.gz"
      sha256 "79ec701fdfc63731fb04f0d08a959848e674b15efe59a82e44e7aab543d9e3bd"
    else
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.7/one-click-ai-tools_linux_amd64.tar.gz"
      sha256 "2318e8d47b27f3d1d930ee7562ec467d45c873a500c132bf39aea22e0a8fa769"
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
