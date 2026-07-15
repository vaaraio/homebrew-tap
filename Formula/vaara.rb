class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/40/57/b9fb8833aaa2b167002c9d369a11cb9f286b91c538ac48fb74270fb79171/vaara-1.33.0.tar.gz"
  sha256 "8fe1913e710f4e5dbe55a42767f7e66d00d14dee959207f323934552ae3ea0ef"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
