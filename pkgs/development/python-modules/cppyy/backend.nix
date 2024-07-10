{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  cmake,
  setuptools,
  tree,

  cppInterOp,
}:
buildPythonPackage {
  pname = "cppyy-backend";
  version = "0-unstable-2024-06-10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "compiler-research";
    repo = "cppyy-backend";
    rev = "ad880c45894a1146ccfd3d065b402c42be47d08e";
    hash = "sha256-beHkyvE887O82WvzBrd4PLCVmqhqobCoc7WzdsPKanE=";
  };

  build-system = [ cmake setuptools tree ];
  dependencies = [ cppInterOp ];
  # dontUseCmakeConfigure = true;

  postPatch = ''
    sed -i "/'build': my_cmake_build,/d" setup.py
    sed -i "s,^builddir = None,builddir = \"$PWD/build\"," setup.py
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCppInterOp_DIR=${cppInterOp}"
  ];

  preBuild = ''
    make -j $NIX_BUILD_CORES
    pwd && ls -Al && tree ../python
    mkdir -p ../python/cppyy_backend/lib
    cp libcppyy-backend.so ../python/cppyy_backend/lib/
    cd ..
  '';

  pythonImportsCheck = [ "cppyy-backend" ];
}
