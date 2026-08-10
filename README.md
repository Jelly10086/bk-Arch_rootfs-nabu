# XiaomiPad5 nabu image

Reproducible Arch Linux ARM image sources for Xiaomi Pad 5 (`nabu`).

The verified boot chain is kept unchanged:

```text
ABL boot_b -> Project Aloha BootShim/UEFI -> rEFInd -> UKI -> PARTLABEL=linux
```

Build profiles:

```bash
scripts/build --profile base --clean
scripts/build --profile dev --clean
scripts/build --profile release --clean
```

Generated files are written to `output/`. Device partitioning and flashing are
not part of the image build.

Local-only files may be overlaid through `local-overrides/rootfs/`. That tree is
ignored by Git and is never included in public build metadata.
