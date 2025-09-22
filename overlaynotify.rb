class Overlaynotify < Formula
  desc "Lightweight macOS CLI tool for centered overlay notifications"
  homepage "https://github.com/zzOzz/overlaynotify"
  url "https://github.com/zzOzz/overlaynotify/releases/download/v1.0.3/OverlayNotify"
  sha256 "aa8b3eb3d0c0fc7bd69ba79b005cd66ba2837bf2eef754bea3883c9322cbe077"
  license "MIT"

  depends_on :macos

  def install
    bin.install "OverlayNotify"
  end
end