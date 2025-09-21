class Overlaynotify < Formula
  desc "Lightweight macOS CLI tool for centered overlay notifications"
  homepage "https://github.com/zzOzz/overlaynotify"
  url "https://github.com/zzOzz/overlaynotify/releases/download/v1.0.0c/OverlayNotify"
  sha256 "23dbc7c5dd683c52d6e76b148fcea2f3da513435686d0922c8541c04bb59a3b6"
  license "MIT"

  depends_on :macos

  def install
    bin.install "OverlayNotify"
  end
end