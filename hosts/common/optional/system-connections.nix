{ lib, config, ... }:
let
  # List of NetworkManager connections
  connections = [
    "00a7e650-9832-4cfa-9063-5480184eeb37"
    "019e66f7-392e-4a59-8eee-3662730f38ed"
    "040b956d-eedd-4f50-9c2d-c32df73c0787"
    "052f3327-3b9b-4987-b205-a87c5abc6359"
    "08310f66-254c-436b-b302-cafa79c615e6"
    "08e0bb90-b59c-4395-8301-12dbf1790156"
    "0a330f9e-70f8-4603-bbcd-88d9e8924408"
    "0a8b8a7b-83a9-4dd5-bb60-4e0ab028db5f"
    "0b5b5ab9-c650-4998-a023-ce45b60007c4"
    "0c09befe-2966-4c41-ae2c-1b9d8b4fc0a0"
    "0ed49c00-8db3-4ea3-b3fe-e5b9e8e60479"
    "0ee42e68-4dbf-4445-bb6b-aac3fba34791"
    "11a20b40-eae5-4f09-9bbb-d9970c802034"
    "12d293cc-0e03-4d73-b2b5-ec47674f282a"
    "176a3165-5485-451c-8801-fc2f75c3a5ad"
    "1853c99f-1fb8-4568-b8e7-14905026c1b0"
    "193b9173-b45a-4623-9f7e-35895b91071e"
    "195704ed-5139-479b-9b6d-4c05d921de58"
    "1aca6629-4d2d-420b-a937-4ecffd5b2ccc"
    "1bbd98fa-638c-4f5f-8353-485995a271eb"
    "1e2199e2-df4d-41c0-8347-f1b4d63c4482"
    "1e4d2e0d-a474-406d-975a-feb090b09990"
    "1fa352ed-a348-4c0a-a1ac-4adb9161c79d"
    "219ce86c-6cf0-4ad9-8881-064f7d54bf37"
    "2418e54b-2c9b-47df-86ef-914a04a61cf4"
    "25faf2b2-9c8e-4800-be7b-a41c0f4168f0"
    "2641e68a-f1bb-4592-b2c0-0999930076d0"
    "2a113481-dcd7-4f27-a02d-0eef8d0bb273"
    "2a640e08-1459-4a28-9f87-5ae4fe61dedb"
    "2a8728a2-d2a1-4eff-ba53-291c854e12fa"
    "309e8e95-5138-4cb8-849a-f097a75bf485"
    "34623159-2b8b-4f2c-bb15-b1c77f9e096b"
    "34db7d8b-d47a-40ea-8828-ef27839ea3ca"
    "34dd0348-9109-4b9e-851c-fa5d73ceccbc"
    "35fb4f65-2765-48cf-ade1-69416ce6ff72"
    "3947f920-f1bc-49c0-8b8e-47fc473b78f3"
    "3cd1f66a-1101-4f57-9ba3-a4e1dd50e708"
    "3d93c974-ac56-4995-9549-a81771212874"
    "3ece1929-6532-4245-819d-eac686656494"
    "3f796d37-09b1-47df-b8cf-c396aaed77c4"
    "4220b815-e50d-44e2-81c0-b60b394ec73c"
    "44738ae9-9166-4199-bd7d-889c1565ac2f"
    "44a4099f-2412-454e-9d4e-cc2deb352c79"
    "4533e5bb-6182-450c-9777-5813ef330c0f"
    "4657cecd-32c1-4cb5-a991-d972080a00e9"
    "48ab972f-8174-432d-b140-3cd85046ffe7"
    "4a4bc3d0-e82d-404d-8b67-25bdee84f2b1"
    "5046e863-37d4-418d-9787-d72f769d82c2"
    "573d3b55-a60d-4eee-97cf-c092faa9c331"
    "57a80448-7e7c-43b6-b506-af0e0ef741ae"
    "5c1e66a4-0741-4ae6-84a4-7ac13e54ea20"
    "5e61127a-f1da-4718-94e8-a17fa6d16cab"
    "621c6e1c-a0cf-4c79-bbce-1a7d2c190848"
    "65c88ca7-78ae-4dea-85b6-2325ad8c08cf"
    "65d4daa0-292f-4ea3-9319-ecb848caf956"
    "69a7616d-8a5a-4077-8586-92d52dd00120"
    "69b857b5-e09f-4724-a608-d3df5d6c2843"
    "69c2533c-a878-4b3e-b2c7-f4f94d963b69"
    "6d72f9dd-4e6c-4d34-af33-c37267c887de"
    "71d5109c-56bb-4c1f-8168-3574fdad20ce"
    "71d8cfdf-a328-4bab-8730-2f69deb34f1f"
    "726ca855-a7e9-4acd-9b24-07858f14cb21"
    "731a15b5-e676-4ba8-ae74-6b9f98e85265"
    "75782bf4-0b65-4d5f-b2f7-1e5f3145b4af"
    "7608b377-8019-455b-ba75-e6c3c5d14c76"
    "7bada782-db83-4e5e-8100-2c4d2bc002c5"
    "7bbad799-0cb0-4ccc-b150-3bc24c939626"
    "7f706ff2-7dc5-4003-ae41-5ad4a2d07d3c"
    "835fb7d4-ede3-4ebe-9713-3268aa489fd4"
    "8504644e-d882-46d6-b94d-9ae7f82bf959"
    "8760738a-9b4c-4092-8d03-96f44d8ac4db"
    "88a87a8f-c779-4180-ad0b-15fbdf040585"
    "8d6490c0-d982-4b2e-afaa-15c2df2c85bf"
    "8e2ae949-9a1f-4305-9b1e-7dee256bf3e5"
    "95d02192-b0c5-41b8-ad39-8261b7fcd137"
    "96964a38-dab8-42a1-aa72-07d15e715994"
    "97c5030c-3ad8-4f27-b1e1-ef2df30f750f"
    "9975c49a-a3d2-4eef-9d6a-0732ac1da53c"
    "9a3b6915-f012-4fa3-a7b1-870caf79a15e"
    "9c49cbdb-cc04-491f-be1f-08545a13c860"
    "9e0fd469-bdc6-4db4-a42b-0d22519b69e9"
    "9e8abc7b-6c76-46b9-bf81-f6d29a7f6512"
    "9f72a3a5-2a6a-4714-9a1d-546d7961dcbf"
    "a1719053-67cc-4173-9904-84112aeb00eb"
    "a3cdcc26-f724-4297-ac13-a6b07aca3311"
    "a77cfb2f-b774-4c4b-8bb2-65a9d0702a38"
    "ac8137fd-3bef-4aaf-8d87-4045f6407e77"
    "aca4d7a9-fd77-44af-b42a-8dda53ca4de8"
    "ae294b39-a4ec-437d-a8b1-5f446c569519"
    "ae86f7fd-65f7-448a-979e-d4b1feb8b909"
    "b03a795a-a18e-4ee7-a5d2-83b2ac2c4bb3"
    "b4959e98-9622-46f4-85d6-8d9238715f2c"
    "b4b2f8cc-91e9-44d9-b3c7-067c10f62fab"
    "b70882fb-333f-458e-b116-a4dd70e780b5"
    "b7549e46-33b6-4763-9788-94e9c0796a10"
    "b921e133-b6f0-4964-b13a-1ea2e5264f6b"
    "bbf58721-8f4a-4375-bf13-7fe18438471d"
    "c158daff-5cdf-4797-bf38-dd6263ebf1c5"
    "c2bcd6dc-a953-47a6-a3e3-1b10b8c9b667"
    "c3b1cabf-7cc6-4127-b985-b26764cf2c37"
    "c3e4ba0f-30bd-4da2-9ee6-04afba8baae1"
    "c42eea76-0c1d-4e1b-8191-ee9b8fd2dc75"
    "c4e1d30e-7c8f-412d-b07f-51c40a212992"
    "c5373233-9878-4271-9df1-c55abf153625"
    "cb63eb28-9160-420c-aa0f-942d95e05229"
    "cb69932b-3efa-4dab-9597-4d90e2f3d22f"
    "cdd62a66-d99f-43c2-9c15-c17e82e53c94"
    "ce5ab0cf-f5c6-4696-b79c-2c52db66c65d"
    "cf9758dc-796a-4bec-97f1-45569ca0c92b"
    "d100b401-baa7-44be-a2c8-9b10da3ae740"
    "d1208354-652d-47d6-a731-10070fd46603"
    "d252549d-5771-4865-ba66-5893e84aa44d"
    "d4269c34-0526-4075-a1f5-e73b8463a2fd"
    "d44f35a1-1bc1-4e3c-a623-712b13243fc2"
    "d4fd2bcf-854d-469a-aee7-72255504a052"
    "d5583951-89f5-4459-8746-aadb4235045d"
    "d7327e10-f803-4384-8b61-2e232df8d3f6"
    "d9ce7493-de5f-4e1c-aa4c-7b57b5189f81"
    "dca50843-ce82-43f8-b520-827ef51c0dd0"
    "dca9a13d-951d-4c41-99aa-4a06b42b40f2"
    "df4f24c6-ef92-4ff4-922d-2367383fd7d1"
    "dff44a43-aaa0-4961-82d7-c7a38c9ea840"
    "e084788e-a15a-4c05-94fe-f60deec9b1b1"
    "e2414dec-d6f7-4ac2-9fa0-e7c668ad476f"
    "e260a9db-5b8e-475e-8f0b-8eabc4c8811d"
    "e2c6a96c-08f9-4f65-b95e-fe89ce1bc6f2"
    "e477b9cc-b193-4442-8cb0-dda3580ef2bd"
    "e70a83ae-c929-4c50-af7d-2861a5cf9f2e"
    "eaa1ea69-ea79-48ef-a9a5-f282bd1a9125"
    "ec8d36ab-a055-4b52-9071-046c796a9212"
    "ef8e1513-ffb2-467b-8c8b-85e8fcf11992"
    "f432ec7d-727d-43f4-958a-49460a60f948"
    "f5363d95-623e-4b37-a531-d2a1e693ebc8"
    "f5560449-bf90-4b35-abd1-eafdeb52ec5c"
    "f6c40750-9ef6-4a45-ad01-25d5f8a2ceda"
    "f82b9c98-3f00-466f-9fda-5012fe0b8327"
    "f988d4a9-2d8d-408c-ab2b-1f6541008be0"
    "facdf80f-a9ef-48e2-850b-4670a156a484"
    "fc0a6477-1439-4bd8-83ac-3c9ebc002026"
    "fc71ac9b-e612-4e47-a7ae-f86893ffa14a"
    "fd927320-5814-4da8-bc9a-617c1997d532"
    "ff1dc6c7-7f34-4e7f-8004-2fcab0fd5933"
  ];
in
lib.mkIf config.networking.networkmanager.enable {
  # Retrieve secrets for NetworkManager connections
  sops.secrets =
    builtins.listToAttrs
      # Map each connection name to an attribute set representing a SOPS secret
      (
        builtins.map (connection: {
          name = "system-connection-${connection}";
          value = {
            format = "binary";
            sopsFile = ./system-connections/${connection}.nmconnection;
            neededForUsers = true;
          };
        }) connections
      );

  # Copy secrets into /etc
  environment.etc =
    builtins.listToAttrs
      # Map each connection name to an attribute set
      # representing a NetworkManager connection
      (
        builtins.map (connection: {
          name = "NetworkManager/system-connections/${connection}.nmconnection";
          value = {
            mode = "0600";
            source = config.sops.secrets."system-connection-${connection}".path;
          };
        }) connections
      );
}
