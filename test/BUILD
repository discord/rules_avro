load("//avro:avro.bzl", "avro_gen", "avro_java_library")

avro_java_library(
    name = "defaults",
    compile_type = "protocol",
    srcs = glob(
        ["src/**/*.avpr"],
    ),
)

avro_java_library(
    name = "customs",
    compile_type = "protocol",
    strings = True,
    srcs = glob(
        ["src/**/*.avpr"],
    ),
)
