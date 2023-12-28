# MPV scripts

## Conventions
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
a script `foo` must either be present as `foo.*` or `foo/main.*`, with the extension matching
the scripting language in use (`.js` or `.lua`, as of mpv v0.37.0) or `.so` for compiled plugins.

The latter form (`foo/main.x`) is strongly recommended for scripts requiring
multiple files (either script code, data, or executables) ; such a script should not
have more than one file matching `main.*` for forwards-compatibility reasons.

[script-location]: https://mpv.io/manual/master/#script-location


## Generic tests

All derivations under [`mpvScripts`](./default.nix) have generic tests injected:
- `scriptName-is-valid` checks that `${drv}/share/mpv/scripts/${drv.passthru.scriptName}` exists,
  as per [`wrapMpv`'s convention](#wrapMpv)
- for directory-packaged scripts (present as `${scriptName}/main.*`), `single-main-in-script-dir`
  checks that a single file matches `main.*`.
