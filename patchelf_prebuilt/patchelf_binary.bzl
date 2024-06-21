"""
Simple rule for running patchelf from the toolchain config
"""

def _patchelf_binary(ctx):
    patchelf = ctx.toolchains["@com_booking_rules_patchelf_prebuilt//patchelf_prebuilt:toolchain_type"].patchelf_prebuiltinfo.target_tool
    script = ctx.actions.declare_file("patchelf")
    ctx.actions.symlink(
        output = script,
        target_file = patchelf,
        is_executable = True,
    )

    return [
        DefaultInfo(
            runfiles = ctx.runfiles(files = [patchelf]),
            executable = script,
        ),
    ]

patchelf_binary = rule(
    implementation = _patchelf_binary,
    attrs = {},
    toolchains = ["@com_booking_rules_patchelf_prebuilt//patchelf_prebuilt:toolchain_type"],
    executable = True,
)
