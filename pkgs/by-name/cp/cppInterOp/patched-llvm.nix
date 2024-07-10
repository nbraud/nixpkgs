{
  lib,
  llvmPackages_17,

  # used to apply the necessary patch
  cppInterOp,
  git,
}:
{
  inherit (llvmPackages_17) libraries lldbPlugins release_version;
  tools = llvmPackages_17.tools.extend (_self: super: {
    clang-unwrapped = super.clang-unwrapped.overrideDerivation (_: {
      pname = "cppInterOp-clang";
      postPatch = ''
        sed 's, \([ab]\)/clang/, \1/,' ${cppInterOp.src}/patches/llvm/clang17-1-NewOperator.patch | ${lib.getExe git} apply -
      '';
      # Sad hack to avoid having to mangle clang's `postInstall`
      preInstall = ''
        touch bin/clang-{tidy-confusable-chars-gen,pseudo-gen}
      '';
    });
  });
}
