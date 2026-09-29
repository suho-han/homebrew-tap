class Oct < Formula
  desc "One binary that organizes your AI coding CLIs — update, quota watch, maintenance"
  homepage "https://github.com/suho-han/one-click-ai-tools"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.6/one-click-ai-tools_darwin_arm64.tar.gz"
      sha256 "f8227e29bf82267b806477a98b77d4b8abec61b363b0343f9e4556ca27d26b00"
    else
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.6/one-click-ai-tools_darwin_amd64.tar.gz"
      sha256 "1b6b1d02787843ef52d3d28f58cff24831634827dfac73dcf44a73d179382702"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.6/one-click-ai-tools_linux_arm64.tar.gz"
      sha256 "3791fa7065a2a807fbd8ebac1d2d42bf3a8315b367493a64412eabd0e78de240"
    else
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.6/one-click-ai-tools_linux_amd64.tar.gz"
      sha256 "866640a61c9af25452b2483abf07ca0ae92785dd54dff19538b6c60c7de8a133"
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
