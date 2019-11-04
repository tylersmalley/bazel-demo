load("@build_bazel_rules_nodejs//:index.bzl", _nodejs_binary = "nodejs_binary", _npm_package = "npm_package", _rollup_bundle = "rollup_bundle")
load("@npm_bazel_typescript//:index.bzl", _ts_library = "ts_library")
load("@npm_bazel_terser//:index.bzl", _terser_minified = "terser_minified")

_DEFAULT_TSCONFIG = "//tools:tsconfig"
_DEFAULT_TSCONFIG_TEST = "//tools:tsconfig-test"

def ts_library(tsconfig = None, testonly = False, deps = [], name = None, **kwargs):
    """Default values for ts_library"""
    deps = deps + ["@npm//tslib"]

    if testonly:
        # Match the types[] in //packages:tsconfig-test.json
        deps.append("@npm//@types/node")

    if not tsconfig and testonly:
        tsconfig = _DEFAULT_TSCONFIG_TEST

    if not tsconfig:
        tsconfig = _DEFAULT_TSCONFIG

    _ts_library(
        tsconfig = tsconfig,
        testonly = testonly,
        deps = deps,
        name = name,
        **kwargs
    )

# def transpile(name, entry_point, srcs):
#     "Common workflow to serve TypeScript to modern browsers"

#     ts_library(
#         name = name + "_lib",
#         srcs = srcs,
#     )

#     rollup_bundle(
#         name = name + "_chunks",
#         deps = [name + "_lib"],
#         sourcemap = "inline",
#         entry_points = {
#             entry_point: "index",
#         },
#         output_dir = True,
#     )

#     # For older browsers, we'll transform the output chunks to es5 + systemjs loader
#     babel(
#         name = name + "_chunks_es5",
#         data = [
#             name + "_chunks",
#             "es5.babelrc",
#             "@npm//@babel/preset-env",
#         ],
#         output_dir = True,
#         args = [
#             "$(location %s_chunks)" % name,
#             "--config-file",
#             "$(location es5.babelrc)",
#             "--out-dir",
#             "$@",
#         ],
#     )

#     # Run terser against both modern and legacy browser chunks
#     terser_minified(
#         name = name + "_chunks_es5.min",
#         src = name + "_chunks_es5",
#     )

#     terser_minified(
#         name = name + "_chunks.min",
#         src = name + "_chunks",
#     )

#     web_package(
#         name = name,
#         assets = [
#             "styles.css",
#         ],
#         data = [
#             "favicon.png",
#             name + "_chunks.min",
#             name + "_chunks_es5.min",
#         ],
#         index_html = "index.html",
#     )
