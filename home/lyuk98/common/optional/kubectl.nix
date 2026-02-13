{ pkgs, ... }:
{
  # Add packages
  home.packages = with pkgs; [
    # Kubernetes cluster management
    kubectl
  ];
}
