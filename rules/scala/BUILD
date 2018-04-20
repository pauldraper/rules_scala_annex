load("//rules:scala.bzl", "annex_scala_library", "annex_scala_runner_toolchain", "basic_scala_binary", "basic_scala_library")
load("//rules:scalafmt.bzl", "annex_scala_format_test")

# Bloop

basic_scala_binary(
    name = "bloop",
    srcs = glob(["bloop/**/*.scala"]),
    main_class = "annex.BloopRunner",
    scala = "//external:scala_annex_scala_basic",
    visibility = ["//visibility:public"],
    deps = [
        ":compiler",
        "//rules/common:worker",
        "//rules/common/third_party/bazel/src/java_tools/buildjar/java/com/google/devtools/build/buildjar/jarhelper",
        "@scala_annex_ch_epfl_scala_bloop_frontend_2_12",
        "@scala_annex_org_scala_sbt_test_interface",
    ],
)

toolchain(
    name = "bloop_toolchain",
    toolchain = ":bloop_toolchain_implementation",
    toolchain_type = "@rules_scala_annex//rules/scala:runner_toolchain_type",
    visibility = ["//visibility:public"],
)

annex_scala_runner_toolchain(
    name = "bloop_toolchain_implementation",
    runner = ":bloop",
    visibility = ["//visibility:public"],
)

# Common

toolchain(
    name = "config_runner_toolchain",
    toolchain = ":config_toolchain_implementation",
    toolchain_type = "@rules_scala_annex//rules/scala:runner_toolchain_type",
    visibility = ["//visibility:public"],
)

annex_scala_runner_toolchain(
    name = "config_toolchain_implementation",
    runner = select({
        ":config_use_bloop": "@rules_scala_annex//rules/scala:bloop",
        "//conditions:default": "@rules_scala_annex//rules/scala:zinc",
    }),
    visibility = ["//visibility:public"],
)

config_setting(
    name = "config_use_bloop",
    values = {
        "define": "use_bloop=true",
    },
)

basic_scala_library(
    name = "compiler",
    srcs = glob(["compiler/**/*.scala"]),
    scala = "//external:scala_annex_scala_basic",
    deps = [
        "//rules/common:worker",
    ],
)

toolchain_type(
    name = "runner_toolchain_type",
    visibility = ["//visibility:public"],
)

# Test

annex_scala_library(
    name = "test",
    srcs = glob(["test/**/*.scala"]),
    scala = "//external:scala_annex_scala",
    visibility = ["//visibility:public"],
    deps = [
        "@scala_annex_net_sourceforge_argparse4j_argparse4j",
        "@scala_annex_org_scala_sbt_compiler_interface",
        "@scala_annex_org_scala_sbt_test_interface",
        "@scala_annex_org_scala_sbt_zinc_apiinfo_2_12",
        "@scala_annex_org_scala_sbt_zinc_core_2_12",
        "@scala_annex_org_scala_sbt_zinc_persist_2_12",
    ],
)

# Zinc

basic_scala_binary(
    name = "zinc",
    srcs = glob(["zinc/**/*.scala"]),
    main_class = "annex.ZincRunner",
    scala = "//external:scala_annex_scala_basic",
    visibility = ["//visibility:public"],
    deps = [
        ":compiler",
        "//rules/common:worker",
        "//rules/common/third_party/bazel/src/java_tools/buildjar/java/com/google/devtools/build/buildjar/jarhelper",
        "@scala_annex_org_scala_sbt_test_interface",
        "@scala_annex_org_scala_sbt_zinc_2_12",
    ],
)

annex_scala_runner_toolchain(
    name = "zinc_toolchain_implementation",
    runner = ":zinc",
    visibility = ["//visibility:public"],
)

toolchain(
    name = "zinc_runner_toolchain",
    toolchain = ":zinc_toolchain_implementation",
    toolchain_type = "@rules_scala_annex//rules/scala:runner_toolchain_type",
    visibility = ["//visibility:public"],
)

# Other

annex_scala_format_test(
    name = "format",
    srcs = glob(["**/*.scala"]),
)