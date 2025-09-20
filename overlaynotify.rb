class Overlaynotify < Formula
  desc "Lightweight macOS CLI tool for centered overlay notifications"
  homepage "https://github.com/zzOzz/overlaynotify"
  url "https://github.com/zzOzz/overlaynotify/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "31e61486ffe10dcfb42f8f39bbe0395bc551648c70bc321f7c353e5eb8fe93da"
  license "MIT"

  depends_on :macos
  depends_on "swift" => :build

  def install
    system "swift", "build", "-c", "release"
    bin.install ".build/release/OverlayNotify"
  end

  test do
    system "#{bin}/OverlayNotify", "--message", "Test"
  end
end