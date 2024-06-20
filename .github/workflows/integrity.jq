# JQ filter to transform sha256 files to a value we can read from starlark.
# NB: the sha256 files are expected to be newline-terminated.
# based on https://github.com/aspect-build/rules_py/blob/main/.github/workflows/integrity.jq

.
# Don't end with an empty object
| rtrimstr("\n")
| split("\n")
| map(
    split(" ")
    | {"key": .[1], "value": .[0]}
  )
| from_entries
