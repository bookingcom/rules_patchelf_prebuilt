# Bazel rules for prebuilt patchelf

This rules for Bazel provide patchelf prebuilt for platforms defined
in `patchelf_prebuilt/platforms/BUILD.bazel`, each tag in this repo
corresponds with a tag in [upstream patchelf](https://github.com/NixOS/patchelf).

Given that our company requires 0.14 built for darwin-arm64 we can't just
pull the binaries from upstream.

## Installation

From the release you wish to use:
<https://github.com/bookingcom/rules_patchelf_prebuilt/releases>
copy the WORKSPACE snippet into your `WORKSPACE` file.

To use a commit rather than a release, you can point at any SHA of the repo.

For example to use commit `abc123`:

1. Replace `url = "https://github.com/bookingcom/rules_patchelf_prebuilt/releases/download/v0.1.0/bookingcom/rules_patchelf_prebuilt-v0.1.0.tar.gz"` with a GitHub-provided source archive like `url = "https://github.com/bookingcom/rules_patchelf_prebuilt/archive/abc123.tar.gz"`
1. Replace `strip_prefix = "rules_patchelf_prebuilt-0.1.0"` with `strip_prefix = "rules_patchelf_prebuilt-abc123"`
1. Update the `sha256`. The easiest way to do this is to comment out the line, then Bazel will
   print a message with the correct value. Note that GitHub source archives don't have a strong
   guarantee on the sha256 stability, see
   <https://github.blog/2023-02-21-update-on-the-future-stability-of-source-code-archives-and-hashes/>
