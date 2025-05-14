{ pkgs, ... }:
{
  # Add FFmpeg to user environment
  home.packages = [ pkgs.ffmpeg-full ];
}
