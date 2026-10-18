class Oct < Formula
  desc "One binary that organizes your AI coding CLIs — update, quota watch, maintenance"
  homepage "https://github.com/suho-han/one-click-ai-tools"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.8/one-click-ai-tools_darwin_arm64.tar.gz"
      sha256 "599a60f31da3425a1eb67129a9d05e30057ae4e2ec2cb3adac37f7fd709443af"
    else
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.8/one-click-ai-tools_darwin_amd64.tar.gz"
      sha256 "88658dceb66f6d12f5d4eeacf8e5ce3f9439677822f7d0db6aaf6ea8ccf5cbbf"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.8/one-click-ai-tools_linux_arm64.tar.gz"
      sha256 "5dbf59aaf0bd32890de6758eb7b403a84896a4e77d12293b89c5317dd922ff90"
    else
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.8/one-click-ai-tools_linux_amd64.tar.gz"
      sha256 "0b165d7b65027c2dc2bdfec1e4a342d5a0ba15c36b79e59ec7b982f39e0025d3"
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
