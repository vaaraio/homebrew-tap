class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Tamper-evident runtime evidence layer for AI agents"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/60/05/2fa012fb73d836326e2c99055fb474701c697c7ac0eed37b0145263a0966/vaara-2.2.0.tar.gz"
  sha256 "6e2305e1cb230387a83549dfe927965ddecb312ff44a2404330d33bc84dfa992"
  license "AGPL-3.0-or-later"

  # cbor2 6 is a Rust extension with no pure-Python fallback.
  depends_on "rust" => :build
  depends_on "cryptography"
  depends_on "python@3.13"

  # The receipt signing libraries are base dependencies from 2.2.0. Homebrew
  # installs with --no-deps, so they are named here: cryptography comes from
  # its formula, cbor2 and rfc8785 as resources.
  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/c6/14/b02446bacfe44351b1689c04937ade007588f44570431880a6937e525e6c/cbor2-6.1.4.tar.gz"
    sha256 "01ecc79a28f33d17331943ce508fc1e21f4b06553c73f874f4c77120d72b2ef9"
  end

  resource "rfc8785" do
    url "https://files.pythonhosted.org/packages/ef/2f/fa1d2e740c490191b572d33dbca5daa180cb423c24396b856f5886371d8b/rfc8785-0.1.4.tar.gz"
    sha256 "e545841329fe0eee4f6a3b44e7034343100c12b4ec566dc06ca9735681deb4da"
  end

  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources
    venv.pip_install buildpath

    %w[vaara vaara-audit vaara-mcp-proxy vaara-mcp-server].each do |cmd|
      bin.install_symlink libexec/"bin"/cmd
    end

    on_macos do
      # The menu bar app is SwiftUI. From the macOS 27 toolchain onwards the
      # State property wrapper is a compiler macro whose plugin ships inside
      # Xcode.app and not in the Command Line Tools, so a bare swiftc fails
      # with "plugin for module 'SwiftUIMacros' not found" (brew build of
      # 1.89.0, 2026-09-20). Build the app only when Xcode is present and let
      # the CLI install on its own otherwise. The caveat says how to get the app.
      unless MacOS::Xcode.installed?
        opoo "Xcode is not installed, so the Vaara menu bar app was not built. " \
             "The vaara CLI is installed. Install Xcode from the App Store and " \
             "run `brew reinstall vaara` to get the app."
        next
      end
      cd "clients/macos" do
        src = "Sources/VaaraMenuBar"
        # Sources/Shared holds the XPC protocol, the policy client and the
        # governed-host list. The app target references those symbols, so
        # both directories have to be compiled into this single module.
        # Globbing only Sources/VaaraMenuBar breaks the build.
        swift_files = Dir["#{src}/*.swift"] + Dir["Sources/Shared/*.swift"]
        odie "no Swift sources found under clients/macos/Sources" if swift_files.empty?
        binary = buildpath/"VaaraMenuBar"

        # Homebrew's build environment hands swiftc the Command Line Tools
        # SDK even when Xcode is installed, and swiftc looks for the SwiftUI
        # macro plugin relative to the SDK it was given. The plugin lives only
        # under Xcode's platform directory, so both are named explicitly.
        xcode_dev = MacOS::Xcode.prefix
        macos_platform = xcode_dev/"Platforms/MacOSX.platform/Developer"
        sdk = Dir[macos_platform/"SDKs/MacOSX*.sdk"].max
        odie "no macOS SDK under #{macos_platform}" if sdk.nil?
        plugins = macos_platform/"usr/lib/swift/host/plugins"
        system "swiftc", "-O", "-target", "arm64-apple-macos13.0",
               "-sdk", sdk, "-plugin-path", plugins,
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
      unless (opt_prefix/"Vaara.app").exist?
        return <<~EOS
          The Vaara CLI is installed. The menu bar app was not built because
          Xcode is not installed: on macOS 27 and later the SwiftUI compiler
          plugin ships only with Xcode. Install Xcode from the App Store, then
          run `brew reinstall vaara`.
        EOS
      end
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
    system libexec/"bin/python", "-c", "import cbor2, cryptography, rfc8785"
    on_macos do
      assert_predicate prefix/"Vaara.app/Contents/MacOS/Vaara", :exist?
    end
  end
end