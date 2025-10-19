QemuToolsInfo = provider(
    fields = {
        "qemu_nbd": "File for qemu-nbd",
        "qemu_img": "File for qemu-img",
    },
)

def _qemu_toolchain_impl(ctx):
    return [
        platform_common.ToolchainInfo(
            qemu = QemuToolsInfo(
                qemu_nbd = ctx.file.qemu_nbd,
                qemu_img = ctx.file.qemu_img,
            ),
        ),
    ]

qemu_toolchain = rule(
    implementation = _qemu_toolchain_impl,
    attrs = {
        "qemu_nbd": attr.label(allow_single_file = True, mandatory = True),
        "qemu_img": attr.label(allow_single_file = True, mandatory = True),
    },
)

