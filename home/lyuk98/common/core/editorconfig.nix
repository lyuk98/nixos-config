{ lib, ... }:
{
  editorconfig = {
    # Enable EditorConfig configuration
    enable = lib.mkDefault true;

    # Write EditorConfig configuration
    settings = {
      # Applied to all files
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        insert_final_newline = true;
        trim_trailing_whitespace = true;
      };

      # Match Rust files
      "*.rs" = {
        indent_size = 4;
        indent_style = "space";
        max_line_length = 100;
      };

      # Match Terraform files
      "*.{tf,tfvars}" = {
        indent_size = 2;
        indent_style = "space";
      };
    };
  };
}
