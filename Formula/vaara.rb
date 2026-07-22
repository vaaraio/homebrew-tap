class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/78/0a/3e480c784124a2b7bb700c95c686791957768521548a5bedec1b765d9f49/vaara-1.50.0.tar.gz"
  sha256 "abd49056e7ebbc4d24c398bed130fcc06b4e7814f734c38db79a4f4c96e65e26"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
