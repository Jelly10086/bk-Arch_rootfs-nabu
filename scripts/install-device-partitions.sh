#!/sbin/bash
set -euo pipefail

disk=/dev/block/sda
expected_product=nabu
esp_mib=350

product=$(getprop ro.product.device)
if [[ "$product" != "$expected_product" ]]; then
    echo "Refusing: product is '$product', expected '$expected_product'" >&2
    exit 1
fi

disk_size=$(blockdev --getsize64 "$disk")
sector_size=$(blockdev --getss "$disk")
if [[ "$disk_size" != 125585850368 || "$sector_size" != 4096 ]]; then
    echo "Refusing: unexpected /dev/block/sda geometry: $disk_size bytes, $sector_size-byte sectors" >&2
    exit 1
fi

userdata_line=$(parted -sm "$disk" unit s print | awk -F: '$1 == "31" && $6 == "userdata" { print; exit }')
if [[ -z "$userdata_line" ]]; then
    echo "Refusing: GPT entry 31 is not the original userdata partition" >&2
    exit 1
fi

IFS=: read -r userdata_num userdata_start userdata_end _ _ userdata_name _ <<< "$userdata_line"
userdata_start=${userdata_start%s}
userdata_end=${userdata_end%s}

if [[ "$userdata_start" != 2654272 || "$userdata_end" != 30660602 ]]; then
    echo "Refusing: userdata bounds changed: ${userdata_start}s..${userdata_end}s" >&2
    exit 1
fi

for mountpoint in /sdcard /data; do
    umount -lf "$mountpoint" 2>/dev/null || true
done
dmsetup remove -f userdata 2>/dev/null || true
if grep -qE '/dev/block/(sda31|dm-[0-9]+) .* /(data|sdcard) ' /proc/mounts; then
    echo "Refusing: userdata remains mounted" >&2
    exit 1
fi

esp_sectors=$((esp_mib * 1024 * 1024 / sector_size))
esp_end=$((userdata_start + esp_sectors - 1))
linux_start=$((esp_end + 1))

parted -s "$disk" unit s \
    rm "$userdata_num" \
    mkpart esp fat32 "${userdata_start}s" "${esp_end}s" \
    mkpart linux ext4 "${linux_start}s" "${userdata_end}s" \
    set 31 esp on

sync
blockdev --rereadpt "$disk" 2>/dev/null || true
sleep 2

esp_line=$(parted -sm "$disk" unit s print | awk -F: '$1 == "31" && $6 == "esp" { print; exit }')
linux_line=$(parted -sm "$disk" unit s print | awk -F: '$1 == "32" && $6 == "linux" { print; exit }')
if [[ -z "$esp_line" || -z "$linux_line" ]]; then
    echo "Partition creation verification failed" >&2
    exit 1
fi

mkfs.fat -F32 -s1 /dev/block/sda31 -n ESPNABU
sync

parted "$disk" unit s print
