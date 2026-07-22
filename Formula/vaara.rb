class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/41/bc/ebd67f0a8f11cf0f5ed2bad62f8ee0d89111e04e1fdde51853f7ae21951a/vaara-1.41.0.tar.gz"
  sha256 "55d3a08af2e45bb7c542c4b7165c999530c5dafe19770b756828f4307c70eb45"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
