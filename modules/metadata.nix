{
  lib,
  config,
  ...
}: {
  options.metadata = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "Real Name";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "mail@example.com";
    };
  };
}
