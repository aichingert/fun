const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "service",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const mongoose = b.dependency("mongoose", .{
        .target = target,
        .optimize = optimize,
    });
    const lib = b.addStaticLibrary(.{
        .name = "mongoose",
        .target = target,
        .optimize = optimize,
    });

    lib.addIncludePath(mongoose.path("."));
    lib.addCSourceFiles(.{
        .root = .{ .dependency = .{
            .dependency = mongoose,
            .sub_path = "",
        } },
        .files = &.{"mongoose.c"},
    });
    lib.linkLibC();
    lib.installHeader(mongoose.path("mongoose.h"), "mongoose.h");
    exe.linkLibrary(lib);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
