const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const exe = b.addExecutable("zig-raspi-sample", "src/main.zig");
    const mode = std.builtin.Mode.ReleaseSmall;

    const target = .{
        .cpu_arch = .arm,
        .cpu_model = .{ .explicit = &std.Target.aarch64.cpu.cortex_a53 },
        .os_tag = .freestanding,
        .abi = .eabihf,
    };

    exe.setTarget(target);
    exe.setBuildMode(mode);

    exe.setLinkerScriptPath(std.build.FileSource{
        .path = "raspi.ld",
    });
    exe.install();

    const bin = b.addInstallRaw(exe, "kernel8.img", .{});
    b.getInstallStep().dependOn(&bin.step);

    const dumpELFCommand = b.addSystemCommand(&[_][]const u8{
        "arm-none-eabi-objdump",
        "-D",
        "-m",
        "arm",
        b.getInstallPath(.{ .custom = "bin" }, exe.out_filename),
    });
    dumpELFCommand.step.dependOn(b.getInstallStep());

    const dumpELFStep = b.step("dump-elf", "Dump the ELF");
    dumpELFStep.dependOn(&dumpELFCommand.step);

    const dumpBinCommand = b.addSystemCommand(&[_][]const u8{
        "arm-none-eabi-objdump",
        "-D",
        "-m",
        "arm",
        "-b",
        "binary",
        b.getInstallPath(bin.dest_dir, bin.dest_filename),
    });

    dumpBinCommand.step.dependOn(&bin.step);
    const dumpBinStep = b.step("dump-bin", "Dump the Binary");

    dumpBinStep.dependOn(&dumpBinCommand.step);
}
