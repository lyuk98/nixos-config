{ lib, ... }:
{
  # Lock the root user
  users.users.root = {
    hashedPassword = lib.mkForce "!";

    # Unset other options to prevent multiple declarations
    initialHashedPassword = lib.mkForce null;
    initialPassword = lib.mkForce null;
    password = lib.mkForce null;
    hashedPasswordFile = lib.mkForce null;
  };
}
