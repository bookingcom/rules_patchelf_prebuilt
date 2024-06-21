"Helpers for testing the repo"

load("@com_booking_rules_patchelf_prebuilt//patchelf_prebuilt/platforms:platforms.bzl", "PLATFORMS")

def build_test_for_platforms(name):
    """Download patchelf prebuilt for all supported platforms

    Args:
        name: name of the default target
    """
    native.genrule(
        name = name,
        srcs = [
            "@patchelf_prebuilt_toolchains//:{}_toolchain".format(x)
            for x in PLATFORMS.keys()
        ],
        outs = ["{}.txt".format(name)],
        cmd = "ls -all $(SRCS) > $@",
    )
