class Overlaynotify < Formula
  desc "Lightweight macOS CLI tool for centered overlay notifications"
  homepage "https://github.com/zzOzz/overlaynotify"
  url "https://github.com/zzOzz/overlaynotify/releases/download/v1.0.0e/OverlayNotify"
  sha256 "1f8a6c4916215ecc6f47a9311253289e98273f2f1d1f0f73e8b5214f2f352e03"
  license "MIT"

  depends_on :macos

  def install
    bin.install "OverlayNotify"
  end
end