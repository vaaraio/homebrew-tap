class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/6b/5f/cedd1d7de71b604a0db1fe7da1fbca0e9cd7deac10d462514a8aa22d7a40/vaara-1.28.0.tar.gz"
  sha256 "0154c5ffe9fa05974773fcdb1674ec83e703a49c91fb8a0d7c9f6dbc67c69b1b"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
