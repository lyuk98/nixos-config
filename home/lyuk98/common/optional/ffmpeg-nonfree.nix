{ pkgs, ... }:
{
  # Add FFmpeg to user environment
  home.packages = [
    # Add support for non-free Fraunhofer FDK AAC
    ((pkgs.ffmpeg-full.override { withUnfree = true; }).overrideAttrs
      # Skip post-bulid checks to speed up installation
      (_: { doCheck = false; })
    )
  ];
}
