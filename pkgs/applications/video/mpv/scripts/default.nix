{ lib
, callPackage
, config
, newScope
}:

let
  inherit (lib) isFunction functionArgs hasSuffix removeSuffix mapAttrs optionalAttrs;

  flatMap = with lib.attrsets; f:
    foldlAttrs (acc: key: val: unionOfDisjoint acc (f key val)) {};
in

lib.makeScope newScope (self:
  let fromFile = fileName:
    let v = import ./${fileName}; in
    assert isFunction v;
    if functionArgs v == { lib = false; } then
      # This is expected to produce an attrset of derivations
      mapAttrs (_: drv: self.callPackage drv {}) (v { inherit lib; })
    else
      # This should be a file with a single derivation
      { ${removeSuffix ".nix" fileName} = self.callPackage v {}; }
    ;
  in flatMap (name: type: optionalAttrs
    (hasSuffix ".nix" name && name != "default.nix" && type == "regular")
    (fromFile name)
  ) (builtins.readDir ./.)
  // lib.optionalAttrs config.allowAliases {
    youtube-quality = throw "'youtube-quality' is no longer maintained, use 'quality-menu' instead"; # added 2023-07-14
  }
)
