# Copyright 2017 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Support functions for manipulating intermediate files."""

load("@build_bazel_rules_apple//apple:utils.bzl", "optionally_prefixed_path")


def _intermediate(ctx, pattern, path=None, prefix=None):
  """Returns a new intermediate file.

  Args:
    ctx: The Skylark context.
    pattern: A pattern used to derive the path and name of the file. If the
        placeholder `%{name}` is in the string, it will be replaced with
        `ctx.label.name` (that is, the name of the current building target).
        Likewise, `%{path}` will be substituted with the `path` argument.
    path: The path to be substituted for `%{path}`.
    prefix: An optional prefix that, if present, will be added just before
        `%{path}`, separated by the rest of the path by a slash.
  Returns:
    A new `File` object.
  """
  name = pattern.replace("%{name}", ctx.label.name)
  if path:
    name = name.replace("%{path}", optionally_prefixed_path(path, prefix))
  else:
    name = optionally_prefixed_path(name, prefix)
  return ctx.new_file(name)


# Define the loadable module that lists the exported symbols in this file.
file_support = struct(
    intermediate=_intermediate,
)
