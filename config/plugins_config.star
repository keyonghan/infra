#!/usr/bin/env lucicfg
# Copyright 2020 The Flutter Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
"""
Configurations for the plugins repository.
"""

load("//lib/common.star", "common")
load("//lib/repos.star", "repos")

def _setup():
    platform_args = {
        "windows": {
            "caches": [swarming.cache(name = "pub_cache", path = ".pub-cache")],
        },
    }
    plugins_define_recipes()
    plugins_try_config(platform_args)

def plugins_define_recipes():
    # Defines recipes
    luci.recipe(
        name = "plugins/plugins",
        cipd_package = "flutter/recipe_bundles/flutter.googlesource.com/recipes",
        cipd_version = "refs/heads/master",
    )

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
        add_cq = True,
        caches = [
            swarming.cache(name = "pub_cache", path = ".pub_cache"),
        ],
    )

plugins_config = struct(setup = _setup)
