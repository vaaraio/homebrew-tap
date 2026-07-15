class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/39/bc/b7bd344f35028605263de2c7e00e77588420e249c3b196a4a1a03cc18e38/vaara-1.31.0.tar.gz"
  sha256 "3362ed872e3fdbc5363b66a9853ccca45b88edacb23a8e97c00cbf2a237cf5ad"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
