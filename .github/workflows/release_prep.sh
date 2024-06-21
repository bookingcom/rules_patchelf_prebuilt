#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

# Set by GH actions, see
# https://docs.github.com/en/actions/learn-github-actions/environment-variables#default-environment-variables
TAG=${GITHUB_REF_NAME}
# The prefix is chosen to match what GitHub generates for source archives
# This guarantees that users can easily switch from a released artifact to a source archive
# with minimal differences in their code (e.g. strip_prefix remains the same)
PREFIX="rules_patchelf_prebuilt-${TAG:1}"
ARCHIVE="rules_patchelf_prebuilt-$TAG.tar.gz"
ARCHIVE_TMP=$(mktemp)

# NB: configuration for 'git archive' is in /.gitattributes
git archive --format=tar --prefix=${PREFIX}/ ${TAG} > $ARCHIVE_TMP

############
# Patch up the archive to have integrity hashes for built binaries that we downloaded in the GHA workflow.
# Now that we've run `git archive` we are free to pollute the working directory.

# Delete the placeholder file
tar --file $ARCHIVE_TMP --delete ${PREFIX}/patchelf_prebuilt/private/integrity.bzl

INTEGRITY=$(jq \
  --from-file .github/workflows/integrity.jq \
  --slurp \
  --raw-input tools/prebuilt/current/*.sha256 \
)

mkdir -p ${PREFIX}/patchelf_prebuilt/private
cat >${PREFIX}/patchelf_prebuilt/private/integrity.bzl <<EOF
"Generated during release by release_prep.sh, using integrity.jq"

RELEASED_BINARY_INTEGRITY = ${INTEGRITY}
EOF

tar --file $ARCHIVE_TMP --append ${PREFIX}/patchelf_prebuilt/private/integrity.bzl

# END patch up the archive
############

gzip < $ARCHIVE_TMP > $ARCHIVE
SHA=$(shasum -a 256 $ARCHIVE | awk '{print $1}')

cat << EOF
## Using Bzlmod with Bazel 6 or greater

1. (Bazel 6 only) Enable with \`common --enable_bzlmod\` in \`.bazelrc\`.
2. Add to your \`MODULE.bazel\` file:

\`\`\`starlark
bazel_dep(name = "com_booking_rules_patchelf_prebuilt", version = "${TAG:1}")
\`\`\`

## Using WORKSPACE

WORKSPACE mode is not supported
EOF
