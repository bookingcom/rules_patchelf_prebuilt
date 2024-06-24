# Bazel rules for prebuilt patchelf

This rules for Bazel provide patchelf prebuilt for platforms defined
in `patchelf_prebuilt/platforms/BUILD.bazel`, each tag in this repo
corresponds with a tag in [upstream patchelf](https://github.com/NixOS/patchelf).

Given that our company requires 0.14 built for darwin-arm64 we can't just
pull the binaries from upstream.

## Installation

### Using Bzlmod with Bazel 6 or greater

1. (Bazel 6 only) Enable with `common --enable_bzlmod` in `.bazelrc`.
2. Add to your `MODULE.bazel` file:

```starlark
bazel_dep(name = "com_booking_rules_patchelf_prebuilt", version = "0.14.5")
```

### Using WORKSPACE

WORKSPACE mode is not supported
