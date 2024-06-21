"""Provides a simple way to test your rules as an external workspace.
Add a basic smoke-test target below.
"""

load("@bazel_skylib//rules:build_test.bzl", "build_test")
load("@com_booking_rules_patchelf_prebuilt//patchelf_prebuilt:patchelf_binary.bzl", "patchelf_binary")
load(":test.bzl", "build_test_for_platforms")

genrule(
    name = "execute_patchelf",
    srcs = [":patchelf"],
    outs = ["empty.txt"],
    cmd = "$(location :patchelf) --version > $@",
)

# Replace with a usage of your rule/macro
filegroup(name = "empty")

build_test(
    name = "smoke_test",
    targets = [
        # targets you add above
        ":execute_patchelf",
        ":patchelf_all_plats",
    ],
)

patchelf_binary(
    name = "patchelf",
)

build_test_for_platforms(
    name = "patchelf_all_plats",
)
