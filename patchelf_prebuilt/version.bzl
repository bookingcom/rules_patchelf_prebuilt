"version information. replaced with stamped info with each release"

# Automagically "stamped" by git during `git archive` thanks to `export-subst` line in .gitattributes.
# See https://git-scm.com/docs/git-archive#Documentation/git-archive.txt-export-subst
_VERSION_PRIVATE = "$Format:%(describe:tags=true)$"

def _get_version_and_is_prerelease():
    version = "0.0.0" if _VERSION_PRIVATE.startswith("$Format") else _VERSION_PRIVATE.replace("v", "", 1)

    # Whether rules_py is a pre-release, and therefore has no release artifacts to download.
    # NB: When GitHub runs `git archive` to serve a source archive file,
    # it honors our .gitattributes and stamps this file, e.g.
    # _VERSION_PRIVATE = "v2.0.3-7-g57bfe2c1"
    # From https://git-scm.com/docs/git-describe:
    # > The "g" prefix stands for "git"

    is_prerelease = version == "0.0.0" or version.find("g") >= 0
    version = "0.14.5" if version == "0.0.0" else version

    return version.split("-", 1)[0], is_prerelease

VERSION, IS_PRERELEASE = _get_version_and_is_prerelease()
