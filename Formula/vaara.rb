class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/41/9f/a67f83a62331d1d29aadc52b25e25350beff1b51efc65da93a6cd45c04eb/vaara-1.39.0.tar.gz"
  sha256 "67226e8089a68d9d1eaa6286cdaf55cb20b270fee711ec9ecce5303c55f645f7"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
