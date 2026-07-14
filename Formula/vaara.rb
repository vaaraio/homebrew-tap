class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/e0/72/ce3292297b44ccad53584e121b86e3eb2b5414e89493b1ece963eb9da095/vaara-1.30.0.tar.gz"
  sha256 "afb2534ac041405b638a9b4cf15c9bb016f52ad88be11cc7fa66b412aaf389d3"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
