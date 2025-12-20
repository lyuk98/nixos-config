{ config, ... }:
{
  # Create entity representing DigitalOcean Virtual Private Cloud (VPC) network
  topology.networks.digitalocean =
    let
      inherit (config.lib.topology) getIcon;
    in
    {
      cidrv4 = "10.114.0.0/20";

      icon = getIcon "digital-ocean" "svg";
      name = "DigitalOcean VPC Network";

      style = {
        primaryColor = "#0080FF";
        pattern = "solid";
      };
    };
}
