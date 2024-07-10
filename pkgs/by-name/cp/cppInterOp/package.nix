{
  lib,
  callPackage,
  fetchFromGitHub,
  gitUpdater,
  overrideCC,
  stdenv,

  cmake,
  ninja,
}:
let
  llvmPackages = callPackage ./patched-llvm.nix { };
  stdenv' = overrideCC stdenv llvmPackages.tools.clang;
in
stdenv'.mkDerivation rec {
  pname = "cppInterOp";
  version = "1.3.0";
  # TODO(nicoo): split dev output; requires fixing assumptions in cppyy-backend first

  src = fetchFromGitHub {
    owner = "compiler-research";
    repo = "CppInterOp";
    rev = "refs/tags/v${version}";
    hash = "sha256-6A5NOr66ENgTpGzWeDbG+S3W4iwVMY7EyI/Oks6W5wk=";
  };

  nativeBuildInputs = with llvmPackages.tools; [
    cmake
    ninja

    clang
    clang-unwrapped  # necessary for CMake to find libclang
    llvm
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DUSE_REPL=ON"
    "-DCPPINTEROP_ENABLE_TESTING=OFF"  # TODO(nicoo): fix upstream's CMake to work with a ready-built gtest
  ];

  passthru = {
    inherit llvmPackages;
    stdenv = stdenv';

    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "C/C++ compiler as a library";
    homepage = "https://github.com/compiler-research/CppInterOp";
    license = lib.licenses.asl20-llvm;
    maintainers = lib.teams.cppyy.members;
  };
}
