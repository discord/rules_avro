load("//avro:repositories.bzl", "avro_repositories")

_avro_filetypes = [".avsc", ".avpr"]

def _commonprefix(m):
    if not m: return ''
    s1 = min(m)
    s2 = max(m)
    for i in range(0, len(s1)):
        if s1[i] != s2[i]:
            return s1[:i]
    return s1

def _new_generator_command(ctx, src_dir, gen_dir):
  java_runtime = ctx.attr._jdk[java_common.JavaRuntimeInfo]
  java_path = "%s/bin/java" % java_runtime.java_home
  gen_command  = "{java} -jar {tool} compile".format(
     java=java_path,
     tool=ctx.file._avro_tools.path,
  )

  if ctx.attr.strings:
    gen_command += " -string"

  if ctx.attr.encoding:
    gen_command += " -encoding {encoding}".format(
      encoding=ctx.attr.encoding
    )

  gen_command += " {compile_type} {src} {gen_dir}".format(
    compile_type=ctx.attr.compile_type,
    src=src_dir,
    gen_dir=gen_dir
  )

  return gen_command

def _impl(ctx):
    src_dir = _commonprefix(
      [f.path for f in ctx.files.srcs]
    )
    gen_dir = "{out}-tmp".format(
         out=ctx.outputs.codegen.path
    )
    java_runtime = ctx.attr._jdk[java_common.JavaRuntimeInfo]
    jar_path = "%s/bin/jar" % java_runtime.java_home
    commands = [
        "mkdir -p {gen_dir}".format(gen_dir=gen_dir),
        _new_generator_command(ctx, src_dir, gen_dir),
        # forcing a timestamp for deterministic artifacts
        "find {gen_dir} -exec touch -d @0 {{}} \;".format(
          gen_dir=gen_dir
        ),
        "{jar} cMf {output} -C {gen_dir} .".format(
          jar=jar_path,
          output=ctx.outputs.codegen.path,
          gen_dir=gen_dir
        )
    ]

    inputs = ctx.files.srcs + ctx.files._jdk + [
      ctx.file._avro_tools,
    ]

    ctx.action(
        inputs = inputs,
        outputs = [ctx.outputs.codegen],
        command = " && ".join(commands),
        progress_message = "generating avro srcs",
        arguments = [],
      )

    return struct(
      codegen=ctx.outputs.codegen
    )

avro_gen = rule(
    attrs = {
        "srcs": attr.label_list(
          # TODO: This should change depending on compile_type, or we should split into multiple rules
          allow_files = _avro_filetypes
        ),
        "strings": attr.bool(),
        "encoding": attr.string(),
        "compile_type": attr.string(
          default="schema",
          values=["schema", "protocol"],
        ),
        "_jdk": attr.label(
            default=Label("@bazel_tools//tools/jdk:current_java_runtime"),
            providers = [java_common.JavaRuntimeInfo],
        ),
        "_avro_tools": attr.label(
            cfg = "host",
            default = Label("//external:io_bazel_rules_avro/dependency/avro_tools"),
            allow_single_file = True,
        )
    },
    outputs = {
        "codegen": "%{name}_codegen.srcjar",
    },
    implementation = _impl,
)


def avro_java_library(
  name, srcs=[], strings=None, encoding=None, compile_type=None, visibility=None):
    avro_gen(
        name=name + '_srcjar',
        compile_type = compile_type,
        srcs = srcs,
        strings=strings,
        encoding=encoding,
        visibility=visibility,
    )
    native.java_library(
        name=name,
        srcs=[name + '_srcjar'],
        deps = [
          Label("//external:io_bazel_rules_avro/dependency/avro"),
          Label("//external:io_bazel_rules_avro/dependency/joda_time"),
        ],
        runtime_deps=[
          Label("//external:io_bazel_rules_avro/dependency/jackson_core_asl"),
          Label("//external:io_bazel_rules_avro/dependency/jackson_mapper_asl"),
        ],
        visibility=visibility,
    )
