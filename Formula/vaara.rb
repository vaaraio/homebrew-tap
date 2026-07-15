class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/a7/5a/2c487f2949e30dea86b2af2595e67e4bab991af4038583e4db13a80135dd/vaara-1.37.0.tar.gz"
  sha256 "d66a9d577774283d48184f867da62676b4666347ae4fda339ee4df86150f8bbc"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
