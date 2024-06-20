"Helpers to build patchelf for different platforms"

load("@aspect_bazel_lib//lib:copy_file.bzl", "copy_file")
load("@aspect_bazel_lib//lib:transitions.bzl", "platform_transition_filegroup")
load("@aspect_bazel_lib//lib:write_source_files.bzl", "write_source_files")
load("@aspect_bazel_lib//tools/release:hashes.bzl", "hashes")
load("//patchelf_prebuilt:version.bzl", "VERSION")
load("//patchelf_prebuilt/platforms:platforms.bzl", "PLATFORMS")
load(":patchelf_sources.bzl", "VERSIONS")

def build_for_platform(platform, version):
    """Build patchelf for a given platform and version

    Args:
        platform: The platform to build for.
        version: The version of patchelf to build.
    Returns:
        array of strings composed of built artifact and sha for it
    """
    platform_transition_filegroup(
        name = "patchelf_prebuilt_tool_{}_{}".format(version, platform),
        srcs = ["@patchelf_sources_v{}//:patchelf".format(version)],
        target_platform = "//patchelf_prebuilt/platforms:{}".format(platform),
    )
    artifact = "patchelf-v{}-{}{}".format(version, platform, ".exe" if "windows" in platform else "")
    copy_file(
        name = "copy_{}".format(artifact),
        src = "patchelf_prebuilt_tool_{}_{}".format(version, platform),
        out = artifact,
        is_executable = True,
    )

    hashes(
        name = "{}.sha256".format(artifact),
        src = artifact,
    )

    return [artifact, "{}.sha256".format(artifact)]

def register_all_tools(name):
    """Register all available patchelf versions for all platforms.

    For each available version in //patchelf_prebuilt/private:patchelf_sources.bzl
    it registers a target

    Args:
        name: name of the default target
    """

    default_files = None

    for version in VERSIONS.keys():
        files = []

        for platform in PLATFORMS.keys():
            files.extend(build_for_platform(platform, version))

        write_source_files(
            name = "patchelf-{}".format(version),
            files = dict([["prebuilt/{}/{}".format(version, x), ":{0}".format(x)] for x in files]),
            diff_test = False,
            check_that_out_file_exists = False,
            visibility = ["//visibility:public"],
        )

        if version == VERSION:
            default_files = files

    write_source_files(
        name = name,
        files = dict([["prebuilt/{}/{}".format(name, x), ":{0}".format(x)] for x in default_files]),
        diff_test = False,
        check_that_out_file_exists = False,
        visibility = ["//visibility:public"],
    )
