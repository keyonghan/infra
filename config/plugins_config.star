#!/usr/bin/env lucicfg
# Copyright 2020 The Flutter Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
"""
Configurations for the plugins repository.
"""

load("//lib/common.star", "common")
load("//lib/repos.star", "repos")

# Set default configurations for builders, and setup recipes.
def _setup():
    platform_args = {
        "windows": {
            "caches": [swarming.cache(name = "pub_cache", path = ".pub-cache")],
        },
    }
    plugins_define_recipes()
    plugins_try_config(platform_args)

# Defines recipes for plugins repo.
def plugins_define_recipes():
    luci.recipe(
        name = "plugins/plugins",
        cipd_package = "flutter/recipe_bundles/flutter.googlesource.com/recipes",
        cipd_version = "refs/heads/master",
    )

# Detailed builder configures for different platforms.
#
# [platform_args] has map structure, with platforms as keys.
# Example:  
# {
#    "windows": {
#        "caches": [swarming.cache(name = "pub_cache", path = ".pub-cache")],
#    }
# }
def plugins_try_config(platform_args):
    # Defines a list view for try builders
    list_view_name = "plugins-try"
    luci.list_view(
        name = list_view_name,
        title = "Plugins try builders",
    )

    # Defines plugins Windows platform try builders
    common.windows_try_builder(
        name = "Windows Plugins|windows",
        recipe = "plugins/plugins",
        list_view_name = list_view_name,
        repo = repos.PLUGINS,
        **platform_args["windows"],
    )

plugins_config = struct(setup = _setup)
