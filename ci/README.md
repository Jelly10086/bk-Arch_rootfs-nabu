# CI build chain

The workflow runs natively on GitHub's `ubuntu-24.04-arm` hosted runner. Host
packages are installed from `ubuntu-24.04-arm-packages.txt`. A clean Arch Linux
ARM BaseTree then supplies the native GCC, makepkg and target development
libraries listed in `archlinuxarm-builder-packages.txt`.

Compilation does not use QEMU. The workflow publishes only the compressed ext4
RootFS, UKI and `SHA256SUMS`. It does not flash a device or build a GPT image.

Primary references:

- https://docs.github.com/actions/reference/runners/github-hosted-runners
- https://docs.github.com/actions/reference/workflows-and-actions/workflow-syntax
- https://docs.github.com/actions/how-tos/monitor-workflows/use-the-visualization-graph
- https://docs.github.com/actions/using-workflows/caching-dependencies-to-speed-up-workflows
- https://github.com/systemd/mkosi
- https://mkosi.systemd.io/
- https://archlinuxarm.org/platforms/armv8/generic
- https://github.com/TwinbornPlate75/linux-nabu
- https://github.com/Kumar-Jy/nabu-pkgs
- https://github.com/Kumar-Jy/nabu-pkgs/tree/main/packages/linux-nabu
- https://github.com/Kumar-Jy/Nabu-arch-images
