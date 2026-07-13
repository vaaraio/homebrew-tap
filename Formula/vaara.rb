class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/e6/01/3afe4bdbe59fa7f03a5ff2be393f2d6b5e08bb523405f8206c78d7aa1bb9/vaara-1.27.0.tar.gz"
  sha256 "0ecd8f2b75960995d8065b3d80999b96013fa614cf2433a7a24ff507e133d268"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
