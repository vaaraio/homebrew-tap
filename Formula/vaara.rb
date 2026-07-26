class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/0d/95/fe8d965ef8c8abcbed579353b9c82a955b09013e598a0230507a2b3f1117/vaara-1.51.1.tar.gz"
  sha256 "3573c29661fa12199af788db54da29d34857f5fedd12216bf8bb97b3a7f1efa8"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
