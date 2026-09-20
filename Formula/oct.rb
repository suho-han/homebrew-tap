class Oct < Formula
  desc "One binary that organizes your AI coding CLIs — update, quota watch, maintenance"
  homepage "https://github.com/suho-han/one-click-ai-tools"
  version "0.1.5"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.5/one-click-ai-tools_darwin_arm64.tar.gz"
      sha256 "d8f495bb1b343287c1684b34e21e8a6ef61a1eedb5472f4d109593a8004a41df"
    else
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.5/one-click-ai-tools_darwin_amd64.tar.gz"
      sha256 "1d21936f79e804f6a34a81ed35f7c4c07fb28ff4051dc75517f88cfc67d7a836"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.5/one-click-ai-tools_linux_arm64.tar.gz"
      sha256 "a3415f688422f38f61a5b350096440c47ce2db00e78e44a40d21295e7c557ffe"
    else
      url "https://github.com/suho-han/one-click-ai-tools/releases/download/v0.1.5/one-click-ai-tools_linux_amd64.tar.gz"
      sha256 "1ee4741886aad74328d2c9fdbbb376ccdc3740d63371b604d962044b4854d5ba"
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
