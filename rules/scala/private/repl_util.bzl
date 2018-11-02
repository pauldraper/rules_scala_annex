load("//rules/common:private/utils.bzl", _write_launcher = "write_launcher")

def repl_util(ctx, prefix, bin):
    scala_configuration = ctx.attr.scala[_ScalaConfiguration]
    zinc_configuration = ctx.attr.scala[_ZincConfiguration]

    args = ctx.actions.args()
    args.add("--compiler_bridge", zinc_configuration.compiler_bridge.short_path)
    args.add_all("--compiler_classpath", scala_configuration.compiler_classpath, map_each = _short_path)
    args.add_all("--classpath", classpath, map_each = _short_path)
    args.add_all(ctx.attr.scalacopts, format_each = "--compiler_option=%s")
    args.set_param_file_format("multiline")
    args_file = ctx.actions.declare_file("{}/repl.params".format(prefix))
    ctx.actions.write(args_file, args)

    launcher_files = _write_launcher(
        ctx,
        prefix,
        ctx.outputs.bin,
        runner_classpath,
        "annex.repl.ReplRunner",
        [ctx.expand_location(f, ctx.attr.data) for f in ctx.attr.jvm_flags] + [
            "-Dbazel.runPath=$RUNPATH",
            "-DscalaAnnex.test.args=${{RUNPATH}}{}".format(args_file.short_path),
        ],
        "export TERM=xterm-color",  # https://github.com/sbt/sbt/issues/3240
    )

    files = depset(
        [args_file, zinc_configuration.compiler_bridge] + launcher_files + scala_configuration.compiler_classpath,
        transitive = [classpath, runner_classpath],
    )
