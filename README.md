# bk-Arch RootFS for Xiaomi Pad 5 (nabu)

[中文](#中文) | [English](#english)

## 中文

本仓库使用 [mkosi](https://github.com/systemd/mkosi) 构建 Xiaomi Pad 5（`nabu`）使用的 Arch Linux ARM RootFS。

mkosi 从官方 Arch Linux ARM BaseTree 生成 RootFS 目录。项目脚本随后安装本地 `[bk]` 仓库的软件包，生成 UKI，并把 RootFS 打包为卷标为 `linux` 的纯 ext4 文件系统镜像。

启动链：

```text
ABL boot_b -> Project Aloha BootShim/UEFI -> rEFInd -> UKI -> PARTLABEL=linux
```

### 构建

公开构建使用 Ubuntu 24.04 ARM64。GitHub Actions runner 为 `ubuntu-24.04-arm`。编译和 RootFS 操作都在 AArch64 环境执行，不使用 QEMU。

Ubuntu 依赖：

```text
ci/ubuntu-24.04-arm-packages.txt
```

Arch Linux ARM 编译环境依赖：

```text
ci/archlinuxarm-builder-packages.txt
```

构建命令：

```bash
./ci/install-ubuntu-24.04-arm-deps
./scripts/build --profile base --clean --public
./scripts/build --profile dev --clean --public
./scripts/build --profile release --clean --public
```

`scripts/build` 依次执行源码下载、PKGBUILD 打包、本地仓库生成、mkosi RootFS 构建、UKI 和镜像生成以及验证。

构建配置：

- `base`：Arch Linux ARM、nabu 内核和固件、基础命令行工具。
- `dev`：`base` 加编译器、调试工具和内核头文件。
- `release`：`base` 加 Hyprland、Noctalia、greetd、触摸键盘和输入法。

### 本地产物

完整本地构建写入 `output/`：

```text
output/bk-nabu-rootfs.img
output/arch-linux-nabu.efi
output/esp.img
output/packages/
output/firmware/
output/SHA256SUMS
```

`bk-nabu-rootfs.img` 是纯 ext4 文件系统镜像，不是 GPT 磁盘镜像。

### GitHub Actions

工作流文件为 `.github/workflows/build.yml`。支持手动运行和 `v*` 标签构建。

工作流分开构建内核、用户空间软件包和 RootFS。内核缓存由内核提交、PKGBUILD、配置片段、补丁和构建脚本决定。

工作流只发布：

```text
bk-Arch-nabu_rootfs-<HHMMSS>.img.zst
bk-Arch-nabu_uki-<HHMMSS>.efi
SHA256SUMS
```

CI 不刷写设备，不修改分区，不发布构建目录和未压缩 RootFS。

### 源码和资源

- Arch Linux ARM Base RootFS：[Arch Linux ARM](https://archlinuxarm.org/platforms/armv8/generic)
- nabu 内核：[TwinbornPlate75/linux-nabu](https://github.com/TwinbornPlate75/linux-nabu)
- nabu 打包参考：[Kumar-Jy/nabu-pkgs](https://github.com/Kumar-Jy/nabu-pkgs/tree/main/packages/linux-nabu)
- nabu 镜像参考：[Kumar-Jy/Nabu-arch-images](https://github.com/Kumar-Jy/Nabu-arch-images)
- 平板桌面集成：[Jelly10086/noctalia-pad](https://github.com/Jelly10086/noctalia-pad)

公开来源的 URL、提交和 SHA-256 记录在 `sources.lock`。`scripts/fetch-sources` 下载并校验这些输入。NOSB 固件来自固定的 `ci-bootstrap-v1` Release，不依赖其他 Actions 运行产物。

`local-overrides/rootfs/` 只用于未跟踪的本地覆盖。公开构建要求该目录不存在。

## English

This repository uses [mkosi](https://github.com/systemd/mkosi) to build an Arch Linux ARM RootFS for Xiaomi Pad 5 (`nabu`).

mkosi creates the RootFS directory from the official Arch Linux ARM BaseTree. The project scripts then install packages from the local `[bk]` repository, generate the UKI, and package the RootFS as a plain ext4 filesystem image with the `linux` label.

Boot chain:

```text
ABL boot_b -> Project Aloha BootShim/UEFI -> rEFInd -> UKI -> PARTLABEL=linux
```

### Build

Public builds use Ubuntu 24.04 ARM64. GitHub Actions runs on `ubuntu-24.04-arm`. Compilation and RootFS operations run on AArch64 without QEMU.

Ubuntu dependencies:

```text
ci/ubuntu-24.04-arm-packages.txt
```

Arch Linux ARM builder dependencies:

```text
ci/archlinuxarm-builder-packages.txt
```

Build commands:

```bash
./ci/install-ubuntu-24.04-arm-deps
./scripts/build --profile base --clean --public
./scripts/build --profile dev --clean --public
./scripts/build --profile release --clean --public
```

`scripts/build` fetches sources, builds the PKGBUILD packages, creates the local repository, builds the RootFS with mkosi, generates the UKI and filesystem images, and runs verification.

Profiles:

- `base`: Arch Linux ARM, the nabu kernel and firmware, and base command-line tools.
- `dev`: `base` plus compilers, debugging tools, and kernel headers.
- `release`: `base` plus Hyprland, Noctalia, greetd, the touch keyboard, and input methods.

### Local output

A complete local build writes these files to `output/`:

```text
output/bk-nabu-rootfs.img
output/arch-linux-nabu.efi
output/esp.img
output/packages/
output/firmware/
output/SHA256SUMS
```

`bk-nabu-rootfs.img` is a plain ext4 filesystem image, not a GPT disk image.

### GitHub Actions

The workflow is stored in `.github/workflows/build.yml`. It supports manual runs and builds for `v*` tags.

The workflow builds the kernel, userspace packages, and RootFS in separate jobs. The kernel cache key covers the kernel commit, PKGBUILD, configuration fragments, patches, and build scripts.

The workflow publishes only:

```text
bk-Arch-nabu_rootfs-<HHMMSS>.img.zst
bk-Arch-nabu_uki-<HHMMSS>.efi
SHA256SUMS
```

CI does not flash devices, modify partitions, or publish build directories and uncompressed RootFS images.

### Sources and assets

- Arch Linux ARM Base RootFS: [Arch Linux ARM](https://archlinuxarm.org/platforms/armv8/generic)
- nabu kernel: [TwinbornPlate75/linux-nabu](https://github.com/TwinbornPlate75/linux-nabu)
- nabu packaging reference: [Kumar-Jy/nabu-pkgs](https://github.com/Kumar-Jy/nabu-pkgs/tree/main/packages/linux-nabu)
- nabu image reference: [Kumar-Jy/Nabu-arch-images](https://github.com/Kumar-Jy/Nabu-arch-images)
- Tablet desktop integration: [Jelly10086/noctalia-pad](https://github.com/Jelly10086/noctalia-pad)

Public source URLs, commits, and SHA-256 values are recorded in `sources.lock`. `scripts/fetch-sources` downloads and verifies these inputs. NOSB firmware comes from the fixed `ci-bootstrap-v1` Release and does not depend on artifacts from another Actions run.

`local-overrides/rootfs/` is reserved for untracked local overrides. Public builds require this directory to be absent.
