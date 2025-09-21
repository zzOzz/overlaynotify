class Overlaynotify < Formula
  desc "Lightweight macOS CLI tool for centered overlay notifications"
  homepage "https://github.com/zzOzz/overlaynotify"
  url "https://github.com/zzOzz/overlaynotify/releases/download/v1.0.0b/OverlayNotify"
  sha256 "b138790875dc74a65c70046863ba5ff76c91a57daa5918f171ce698cacfd1a12"
  license "MIT"

  depends_on :macos

  def install
    bin.install "OverlayNotify"
  end
end