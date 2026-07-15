class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/54/0d/5f7db72604ff5fb8379b8b8cfb585d9103358efe2ffefa25a7df2936969e/vaara-1.36.0.tar.gz"
  sha256 "7e1631b004efd4227476b16f8b81709433b4918d97fd2e3f79df0c30f36a174f"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
