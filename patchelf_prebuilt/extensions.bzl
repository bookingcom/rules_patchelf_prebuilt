"""Extensions for bzlmod.

Installs a patchelf_prebuilt toolchain.
Every module can define a toolchain version under the default name, "patchelf_prebuilt".
The latest of those versions will be selected (the rest discarded),
and will always be registered by rules_patchelf_prebuilt.

Additionally, the root module can define arbitrarily many more toolchain versions under different
names (the latest version will be picked for each name) and can register them as it sees fit,
effectively overriding the default named toolchain due to toolchain resolution precedence.
"""

load(":repositories.bzl", "patchelf_prebuilt_register_toolchains")

_DEFAULT_NAME = "patchelf_prebuilt"

patchelf_prebuilt_toolchain = tag_class(attrs = {
    "name": attr.string(doc = """\
Base name for generated repositories, allowing more than one patchelf_prebuilt toolchain to be registered.
Overriding the default is only permitted in the root module.
""", default = _DEFAULT_NAME),
    "patchelf_prebuilt_version": attr.string(doc = "Explicit version of patchelf_prebuilt.", mandatory = True),
})

def _toolchain_extension(module_ctx):
    registrations = {}
    for mod in module_ctx.modules:
        for toolchain in mod.tags.toolchain:
            if toolchain.name != _DEFAULT_NAME and not mod.is_root:
                fail("""\
                Only the root module may override the default name for the patchelf_prebuilt toolchain.
                This prevents conflicting registrations in the global namespace of external repos.
                """)
            if toolchain.name not in registrations.keys():
                registrations[toolchain.name] = []
            registrations[toolchain.name].append(toolchain.patchelf_prebuilt_version)
    for name, versions in registrations.items():
        if len(versions) > 1:
            # TODO: should be semver-aware, using MVS
            selected = sorted(versions, reverse = True)[0]

            # buildifier: disable=print
            print("NOTE: patchelf_prebuilt toolchain {} has multiple versions {}, selected {}".format(name, versions, selected))
        else:
            selected = versions[0]

        patchelf_prebuilt_register_toolchains(
            name = name,
            patchelf_prebuilt_version = selected,
            register = False,
        )

patchelf_prebuilt = module_extension(
    implementation = _toolchain_extension,
    tag_classes = {"toolchain": patchelf_prebuilt_toolchain},
)
