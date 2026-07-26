cask "vaara" do
  version "1.51.1"
  sha256 "ff3161a4b95203dba4e815776e754a3d6f0e8b75d63e6fc6ea6aa446215f9f86"

  url "https://github.com/vaaraio/vaara/releases/download/v#{version}/Vaara.dmg"
  name "Vaara"
  desc "Vaara macOS menu bar app"
  homepage "https://vaara.io"

  app "Vaara.app"

  zap trash: [
    "~/Library/Application Support/Vaara",
    "~/Library/Preferences/io.vaara.menubar.plist",
  ]
end
