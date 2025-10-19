def _qemu_build_image_impl(ctx):
    qemu_img = ctx.toolchains["//tools/qemu:toolchain_type"].qemu.qemu_img
    qemu_nbd = ctx.toolchains["//tools/qemu:toolchain_type"].qemu.qemu_nbd

    script = ctx.file.script
    src = ctx.file.src
    out = ctx.outputs.out

    # Now run the edit script with the tool binaries
    ctx.actions.run(
        inputs = [script, qemu_img, qemu_nbd],
        outputs = [out],
        arguments = [
            qemu_img.path,
            qemu_nbd.path,
            out.path,
        ],
        executable = script,
        progress_message = "Building bootable archlinux iso in qcow2 image.",
    )

qemu_build_image = rule(
    implementation = _qemu_build_image_impl,
    attrs = {
        "src": attr.label(allow_single_file=True),
        "script": attr.label(allow_single_file=True),
        "out": attr.output(mandatory=True),
    },
    toolchains = ["//tools/qemu:toolchain_type"],
)

