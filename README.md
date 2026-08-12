# bk-Arch RootFS for Xiaomi Pad 5 (nabu)

仓库使用 [mkosi](https://github.com/systemd/mkosi) 构建 Xiaomi Pad 5（nabu）使用的 Arch Linux ARM RootFS。

mkosi 从官方 Arch Linux ARM BaseTree 生成 RootFS 目录。项目脚本随后安装本地 `[bk]` 仓库的软件包，生成 UKI，并把 RootFS 打包为卷标为 `linux` 的纯 ext4 文件系统镜像。

启动链：

```text
ABL boot_b -> Project Aloha BootShim/UEFI -> rEFInd -> UKI -> PARTLABEL=linux
```

### 构建

Action构建使用 Ubuntu 24.04 ARM64。GitHub Actions runner 为 `ubuntu-24.04-arm`。编译和 RootFS 操作都在 AArch64 环境执行，不使用 QEMU。

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

`bk-nabu-rootfs.img` 是ext4文件系统镜像，不是 GPT 磁盘镜像。

### GitHub Actions

工作流文件为 `.github/workflows/build.yml`。支持手动运行和 `v*` 标签构建。

工作流分开构建内核、用户空间软件包和 RootFS。内核缓存由内核提交、PKGBUILD、配置片段、补丁和构建脚本决定。

工作流发布：

```text
bk-Arch-nabu_rootfs-<HHMMSS>.img.zst
bk-Arch-nabu_uki-<HHMMSS>.efi
SHA256SUMS
```
