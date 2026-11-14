class Oct < Formula
  desc "One binary that organizes your AI coding CLIs — update, quota watch, maintenance"
  homepage "https://github.com/suho-han/one-click-ai-tools"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.10/one-click-ai-tools_darwin_arm64.tar.gz"
      sha256 "adc9d5362e135820aed3df68f73095f7b5aadef008ae1c05ea34cf3b5727ad71"
    else
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.10/one-click-ai-tools_darwin_amd64.tar.gz"
      sha256 "4c9e563889368a1f09d060a93ba0a65be60502fa86702ec98e561d9cea0b0afa"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.10/one-click-ai-tools_linux_arm64.tar.gz"
      sha256 "a7ffae22ad02b83ccd2d362a67e495a4f8dbfc610ff3f50dec650b2b33f8f281"
    else
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.10/one-click-ai-tools_linux_amd64.tar.gz"
      sha256 "37f09873da9043e8088511164ffb37657eebbb0d33f39bc573f6e8a4c33f7880"
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
