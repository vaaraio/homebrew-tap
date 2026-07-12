# Vaara Homebrew tap

Homebrew formulae for [Vaara](https://github.com/vaaraio/vaara), the policy gate and signed, verifiable audit trail for AI agent tool calls.

## Install

```bash
brew tap vaaraio/tap
brew trust vaaraio/tap
brew install vaara
```

Recent Homebrew versions require the `brew trust` step once for any tap outside homebrew-core; if your brew has no `trust` command, skip that line.

This installs the `vaara`, `vaara-audit`, `vaara-mcp-proxy`, and `vaara-mcp-server` commands. The core has no Python dependencies beyond the interpreter.

Optional extras (the ML classifier, signed export, and others) are pip features rather than brew ones; for those, use a virtualenv and `pip install 'vaara[export]'` as described in the [main README](https://github.com/vaaraio/vaara#readme).

## Verify

```bash
vaara version
```

Releases on PyPI carry SLSA Build Level 3 provenance; see [signing-keys.md](https://github.com/vaaraio/vaara/blob/main/docs/signing-keys.md) for release verification.
