{
  security.tpm2 = {
    # Enable support for Trusted Platform Module 2
    enable = true;

    # Enable TPM2 PKCS#11 tool
    # and expose /run/current-system/sw/lib/libtpm2_pkcs11.so
    pkcs11.enable = true;

    # Set up TCTI environment
    tctiEnvironment.enable = true;
  };

  # Enable TPM2 support in initrd
  boot.initrd.systemd.tpm2.enable = true;
}
