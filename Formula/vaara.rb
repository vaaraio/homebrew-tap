class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/60/d8/84d6dac2a010a11ec4f7c90b91887e4239e6a5064c460b98beee6d3d7579/vaara-1.29.0.tar.gz"
  sha256 "87b820d8faaba7d23b75460221683eafdbb08041a25352509d2f5f26d718f797"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
