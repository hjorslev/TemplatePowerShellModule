# Contributing

## Follow SemVer guidelines for versioning

[SemVer](https://semver.org/) is a public convention that describes how to
structure and change a version to allow easy interpretation of changes.
The version for your package must be included in the manifest data.

- The version should be structured as three numeric blocks separated by periods,
as in `0.1.1` or `4.11.192`.
- Versions starting with `0` indicate that the package isn't yet production ready,
and the first number should only begin with `0` if that's the only number used.
- Changes in the first number (`1.9.9999` to `2.0.0`) indicate major and breaking
changes between the versions.
- Changes to the second number (`1.1` to `1.2`) indicate feature-level changes,
such as adding new cmdlets to a module.
- Changes to the third number indicate non-breaking changes, such as new parameters,
updated samples, or new tests.
- When listing versions, PowerShell will sort the versions as strings, so `1.01.0`
will be treated as greater than `1.001.0`.
