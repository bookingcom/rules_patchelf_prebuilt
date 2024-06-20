""

PLATFORMS = {
    "linux-amd64": [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    "linux-arm64": [
        "@platforms//os:linux",
        "@platforms//cpu:arm64",
    ],
    "darwin-amd64": [
        "@platforms//os:osx",
        "@platforms//cpu:x86_64",
    ],
    "darwin-arm64": [
        "@platforms//os:osx",
        "@platforms//cpu:arm64",
    ],
    "windows-amd64": [
        "@platforms//os:windows",
        "@platforms//cpu:x86_64",
    ],
    "windows-arm64": [
        "@platforms//os:windows",
        "@platforms//cpu:arm64",
    ],
}

# buildifier: disable=unnamed-macro
def register_platforms():
    for platform, constraints in PLATFORMS.items():
        native.platform(
            name = platform,
            constraint_values = constraints,
            visibility = ["//visibility:public"],
        )
