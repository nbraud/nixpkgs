# MPV scripts

## Conventions
### `mpvScripts` scope

`pkgs.mpvScripts` is a scope which is automatically populated from the `.nix`
files in this directory. (other than `default.nix`)
They must define a function matching either of those signatures:
- `{ lib } → AttrSet[ AttrSet → Derivation ]`, taking **only** `lib` and returning an attrset
  whose attributes are mapped with `callPackage` and added to the scope;
- `{ lib, dep1, ... } → Derivation`, taking in dependencies and whose result is in scope as
  `mpvScript.${removeSuffix ".nix" fileName}`.

Package maintainers do not need to edit `default.nix` when adding a new script,
it is enough to add nix code in this directory.

Note: attrsets of derivations do not take their dependencies at the top-level (of the file)
      to avoid causing an infinite recursion in `lib.makeScope`.


### `wrapMpv`

MPV scripts are expected to be used via [`wrapMpv`](../wrapper.nix), meaning that:
- each script must be packaged under `$out/share/mpv/scripts/${scriptName}`,
  where `scriptName` is a passthru attribute;
- necessary environment variables — such as `PATH`, `LUA_C?PATH`, `PYTHONPATH` etc. —
  can be set via the `extraWrapperArgs` passthru attribute, for instance:
  ```nix
  passthru.extraWrapperArgs = [
    "--set"
    "FONTCONFIG_FILE"
    (toString (makeFontsConf {
      fontDirectories = [ "${finalAttrs.finalPackage}/share/fonts" ];
    }))
  ];
  ```


### MPV itself

MPV defines [its own conventions][script-location], as to the contents of `share/mpv/scripts`:
a script `foo` must either be present as `foo.x` or `foo/main.x`, with `x` matching the
scripting language in use (`.js` or `.lua`, as of mpv v0.37.0)

The latter form (`foo/main.x`) is strongly recommended for scripts requiring
multiple files (either script code, data, or executables) ; such a script should not
have more than one file matching `main.*` for forwards-compatibility reasons.

[script-location]: https://mpv.io/manual/master/#script-location
