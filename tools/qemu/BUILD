load("//tools/qemu:toolchain.bzl", "qemu_toolchain")

# Define the toolchain type
toolchain_type(name = "toolchain_type")

# Toolchain instance using these binaries
qemu_toolchain(
    name = "hermetic_qemu_toolchain",
    qemu_nbd = "@qemu_bins//:qemu_nbd",
    qemu_img = "@qemu_bins//:qemu_img",
)

toolchain(
    name = "hermetic_toolchain",
    toolchain_type = ":toolchain_type",
    toolchain = ":hermetic_qemu_toolchain",
)

