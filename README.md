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

GitHub Actions uses the native `ubuntu-24.04-arm` runner. Ubuntu dependencies
are listed in `ci/ubuntu-24.04-arm-packages.txt`; the native Arch Linux ARM
compiler and development packages are listed separately in
`ci/archlinuxarm-builder-packages.txt`. The workflow installs both lists and
does not use QEMU for compilation or target userspace execution.

Generated files are written to `output/`. Device partitioning and flashing are
not part of the image build.

`scripts/fetch-sources` downloads every clean-build input. The base RootFS comes
from an official Arch Linux ARM mirror and is checked against `sources.lock`.
Immutable NOSB firmware is stored in the `ci-bootstrap-v1` GitHub Release, so no
expiring Actions artifact is used. Noctalia Pad is fetched at its locked commit.

Local-only files may be overlaid through `local-overrides/rootfs/`. That tree is
ignored by Git and is never included in public build metadata.
