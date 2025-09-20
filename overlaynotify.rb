class Overlaynotify < Formula
  desc "Lightweight macOS CLI tool for centered overlay notifications"
  homepage "https://github.com/zzOzz/overlaynotify"
  url "https://github.com/zzOzz/overlaynotify/releases/download/v1.0.0a/OverlayNotify"
  sha256 "d590fe997fb58993ac7bd658823fe4cba0283da6270cd31ebce0c84767684356"
  license "MIT"

  depends_on :macos

  def install
    bin.install "OverlayNotify"
  end
end