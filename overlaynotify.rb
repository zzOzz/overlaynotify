class Overlaynotify < Formula
  desc "Lightweight macOS CLI tool for centered overlay notifications"
  homepage "https://github.com/zzOzz/overlaynotify"
  url "https://github.com/zzOzz/overlaynotify/releases/download/v1.0.2a/OverlayNotify"
  sha256 "7582cec05ac5275cd47c720f5295dcd4a5388833ababa671ea14b6376c8454f6"
  license "MIT"

  depends_on :macos

  def install
    bin.install "OverlayNotify"
  end
end