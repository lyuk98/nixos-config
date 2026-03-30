{
  security.apparmor = {
    # Enable the AppArmor Mandatory Access Control system
    enable = true;

    # Kill processes that are confinable but not confined
    killUnconfinedConfinables = true;
  };
}
