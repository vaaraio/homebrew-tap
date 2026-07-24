class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/7c/24/3d3fb42a32106ec373d988d660b0011155e890ba0cb5215891ec08e82b1d/vaara-1.51.0.tar.gz"
  sha256 "7c6cd14fdd9455af5b64162ed3efbefaca622ccefb0c72f6bbbfa8cc19be6fab"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
