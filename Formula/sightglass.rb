class Sightglass < Formula
  desc "Menu bar monitor for what is using your Mac's CPU, battery and memory"
  homepage "https://github.com/mohinpatell/sightglass"
  url "https://github.com/mohinpatell/sightglass/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "cc5e4aab72102ca13867e01c15d89e76948defcf35f793198514400a342ce283"
  license "MIT"
  head "https://github.com/mohinpatell/sightglass.git", branch: "main"

  depends_on macos: :sonoma
  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "Sightglass"
    app = prefix/"Sightglass.app"
    (app/"Contents/MacOS").install ".build/release/Sightglass"
    (app/"Contents").install "Support/Info.plist"
    # Signed on this Mac, so macOS has no downloaded app to warn about.
    system "/usr/bin/codesign", "--force", "--sign", "-", app
    (bin/"sightglass").write <<~SH
      #!/bin/sh
      exec /usr/bin/open "#{opt_prefix}/Sightglass.app" --args "$@"
    SH
    (bin/"sightglass").chmod 0755
  end

  def caveats
    <<~EOS
      Start Sightglass with:
        sightglass
      It appears in the menu bar. To start it at login, tick "Open at login" in its panel.
    EOS
  end

  test do
    assert_predicate prefix/"Sightglass.app/Contents/MacOS/Sightglass", :executable?
  end
end
