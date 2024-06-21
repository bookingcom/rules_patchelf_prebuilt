"Creates repositories that can build patchelf for different versions from upstream"

load("@bazel_tools//tools/build_defs/repo:http.bzl", _http_archive = "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

VERSIONS = {
    "0.14.5": {
        "url": "https://github.com/NixOS/patchelf/releases/download/0.14.5/patchelf-0.14.5.tar.bz2",
        "sha256": "b9a46f2989322eb89fa4f6237e20836c57b455aa43a32545ea093b431d982f5c",
    },
}

def http_archive(name, **kwargs):
    maybe(_http_archive, name = name, **kwargs)

def _patchelf_sources_extension(module_ctx):
    repos = []

    for version, info in VERSIONS.items():
        http_archive(
            name = "patchelf_sources_v{}".format(version),
            url = info["url"],
            build_file = "@//patchelf_prebuilt/private:BUILD.bazel.patchelf",
            strip_prefix = "patchelf-{}".format(version),
            sha256 = info["sha256"],
        )
        repos.append("patchelf_sources_v{}".format(version))

    return module_ctx.extension_metadata(
        root_module_direct_deps = [],
        root_module_direct_dev_deps = repos,
        reproducible = True,
    )

patchelf_sources = module_extension(
    implementation = _patchelf_sources_extension,
    tag_classes = {"register": tag_class()},
)
