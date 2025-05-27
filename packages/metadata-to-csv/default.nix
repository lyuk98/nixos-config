{
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "metadata-to-csv";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "lyuk98";
    repo = "metadata-to-csv";
    tag = "v${version}";
    hash = "sha256-YPTy9xMJkBLz+ceCVHcmL0z/4wUlKnVtlujOqCQIHu0=";
  };

  cargoHash = "sha256-M+d0hyQhSE/ewFo0BYZMFRYuUOInBmGF44F2Yqcn/xA=";

  meta = {
    description = "Retrieve metadata from photos and save it in CSV format";
    mainProgram = pname;
    homepage = "https://github.com/lyuk98/metadata-to-csv";
  };
}
