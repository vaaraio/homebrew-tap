class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Tamper-evident runtime evidence layer for AI agents"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/97/ef/b7681ab6328357fef2c9bb4ed0af33f3683272c310f65d62aabdbc2746e1/vaara-1.57.0.tar.gz"
  sha256 "f815a4aa0a83f1cad2db822f1a8d52978a989a12322a68ceb2136c5fefc5b42e"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

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