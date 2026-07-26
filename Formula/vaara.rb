class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://github.com/vaaraio/vaara/archive/refs/tags/v1.51.1.tar.gz"
  sha256 "335110885a4840cb5d1796b4c96fd18cf434e55e4e188987e61fae38b47c4829"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  patch :DATA

  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install buildpath

    %w[vaara vaara-audit vaara-mcp-proxy vaara-mcp-server].each do |cmd|
      bin.install_symlink libexec/"bin"/cmd
    end

    on_macos do
      cd "clients/macos" do
        src = "Sources/VaaraMenuBar"
        swift_files = Dir["#{src}/*.swift"]
        binary = buildpath/"VaaraMenuBar"

        system "swiftc", "-O", "-target", "arm64-apple-macos13.0",
               "-o", binary, *swift_files

        app = prefix/"Vaara.app"
        (app/"Contents/MacOS").mkpath
        (app/"Contents/Resources").mkpath

        cp binary, app/"Contents/MacOS/Vaara"
        cp_r "#{src}/Resources/icons", app/"Contents/Resources/icons"
        cp "AppIcon.icns", app/"Contents/Resources/"

        (app/"Contents/Info.plist").write <<~PLIST
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
            "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
          <plist version="1.0">
          <dict>
            <key>CFBundleName</key><string>Vaara</string>
            <key>CFBundleDisplayName</key><string>Vaara</string>
            <key>CFBundleIdentifier</key><string>io.vaara.menubar</string>
            <key>CFBundleVersion</key><string>#{version}</string>
            <key>CFBundleShortVersionString</key><string>#{version}</string>
            <key>CFBundleExecutable</key><string>Vaara</string>
            <key>CFBundlePackageType</key><string>APPL</string>
            <key>LSMinimumSystemVersion</key><string>13.0</string>
            <key>LSUIElement</key><true/>
            <key>CFBundleIconFile</key><string>AppIcon</string>
          </dict>
          </plist>
        PLIST

        system "codesign", "--force", "--deep", "--sign", "-", app
      end
    end
  end

  def caveats
    on_macos do
      <<~EOS
        The Vaara menu-bar app is installed to:
          #{opt_prefix}/Vaara.app

        To install it:
          cp -R #{opt_prefix}/Vaara.app /Applications/
          open /Applications/Vaara.app

        Add it to System Settings > General > Login Items to start with macOS.
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
    on_macos do
      assert_predicate prefix/"Vaara.app/Contents/MacOS/Vaara", :exist?
    end
  end
end

__END__
diff --git a/clients/macos/Sources/VaaraMenuBar/VaaraApp.swift b/clients/macos/Sources/VaaraMenuBar/VaaraApp.swift
--- a/clients/macos/Sources/VaaraMenuBar/VaaraApp.swift
+++ b/clients/macos/Sources/VaaraMenuBar/VaaraApp.swift
@@ -33,9 +33,10 @@
     }
 
     private func markImage(for state: GateState) -> NSImage {
-        if let url = Bundle.module.url(
-            forResource: "icons/vaara-\(state.rawValue)", withExtension: "png"),
-           let img = NSImage(contentsOf: url) {
+        let bundle = Bundle.main
+        let resourcePath = bundle.resourcePath ?? ""
+        let iconPath = "\(resourcePath)/icons/vaara-\(state.rawValue).png"
+        if let img = NSImage(contentsOfFile: iconPath) {
             return img
         }
         let color = stateColor(state)
