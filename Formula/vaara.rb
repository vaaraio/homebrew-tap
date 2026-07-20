class Vaara < Formula
  include Language::Python::Virtualenv

  desc "Policy gate and signed, verifiable audit trail for AI agent tool calls"
  homepage "https://vaara.io"
  url "https://files.pythonhosted.org/packages/a9/46/300e290decae53492d70dbac3115a1b29e6513afbb30ef04df44282156b6/vaara-1.38.0.tar.gz"
  sha256 "2e877cb59d346d66049b9fc4d1b015af065a5aeeda8bc3ab7940c5fcdd90eb33"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vaara version")
  end
end
