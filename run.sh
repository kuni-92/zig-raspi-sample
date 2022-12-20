#!/bin/bash

qemu-system-aarch64 -M raspi3 -kernel zig-out/bin/kernel8.img -d in_asm -display none
