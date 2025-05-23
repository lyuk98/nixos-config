{
  programs.appimage = {
    # Enable appimage-run for executing AppImages
    enable = true;

    # Enable binfmt registration to use appimage-run as an interpreter
    binfmt = true;
  };
}
