class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/ec/16/e77993b4bca3f21d0fe0bbfa8df5d3d1cefd3216338be08dd20c6f3a7d46/vaara-1.26.1.tar.gz"
  sha256 "b25c9fa9b0c33419cdec38373771bcce654d0e75fac4fa67281bba1519d14d4d"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
