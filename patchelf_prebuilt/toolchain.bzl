"""This module implements the language-specific toolchain rule.
"""

PatchelfPrebuiltInfo = provider(
    doc = "Information about how to invoke the tool executable.",
    fields = {
        "target_tool_path": "Path to the executable for the target platform.",
        "target_tool": "Executable for the target platform.",
    },
)

# Avoid using non-normalized paths (workspace/../other_workspace/path)
def _to_manifest_path(ctx, file):
    if file.short_path.startswith("../"):
        return "external/" + file.short_path[3:]
    else:
        return ctx.workspace_name + "/" + file.short_path

def _patchelf_prebuilt_toolchain_impl(ctx):
    target_tool_path = _to_manifest_path(ctx, ctx.file.target_tool)

    # Make the $(tool_BIN) variable available in places like genrules.
    # See https://docs.bazel.build/versions/main/be/make-variables.html#custom_variables
    template_variables = platform_common.TemplateVariableInfo({
        "PATCHELF_PREBUILT_BIN": target_tool_path,
    })
    default = DefaultInfo(
        files = depset([ctx.file.target_tool]),
        runfiles = ctx.runfiles(files = [ctx.file.target_tool]),
    )
    patchelf_prebuiltinfo = PatchelfPrebuiltInfo(
        target_tool_path = target_tool_path,
        target_tool = ctx.file.target_tool,
    )

    # Export all the providers inside our ToolchainInfo
    # so the resolved_toolchain rule can grab and re-export them.
    toolchain_info = platform_common.ToolchainInfo(
        patchelf_prebuiltinfo = patchelf_prebuiltinfo,
        template_variables = template_variables,
        default = default,
    )
    return [
        default,
        toolchain_info,
        template_variables,
    ]

patchelf_prebuilt_toolchain = rule(
    implementation = _patchelf_prebuilt_toolchain_impl,
    attrs = {
        "target_tool": attr.label(
            doc = "A hermetically downloaded executable target for the target platform.",
            mandatory = False,
            allow_single_file = True,
        ),
    },
    doc = """Defines a patchelf_prebuilt compiler/runtime toolchain.

For usage see https://docs.bazel.build/versions/main/toolchains.html#defining-toolchains.
""",
)
