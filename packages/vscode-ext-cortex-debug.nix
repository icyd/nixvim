{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "cortex-debug";
    publisher = "marus25";
    version = "1.12.1";
    sha256 = "sha256-ioK6gwtkaAcfxn11lqpwhrpILSfft/byeEqoEtJIfM0=";
  };
  meta.license = lib.licenses.mit;
}
