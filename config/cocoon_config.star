#!/usr/bin/env lucicfg
# Copyright 2019 The Flutter Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
"""
Configurations for the cocoon repository.

The schedulers pull commits indirectly from GoB repo (https://chromium.googlesource.com/external/github.com/flutter/cocoon)
which is mirrored from https://github.com/flutter/cocoon.
"""

load("//lib/common.star", "common")
load("//lib/repos.star", "repos")

def _setup():
    platform_args = {
        "linux": {
            "caches": [swarming.cache(name = "dart_pub_cache", path = ".pub-cache")],
        },
    }
    cocoon_define_recipes()
    device_doctor_recipes()
    cocoon_try_config(platform_args)

def cocoon_define_recipes():
    # Defines recipes
    luci.recipe(
        name = "cocoon",
        cipd_package = "flutter/recipe_bundles/flutter.googlesource.com/recipes",
        cipd_version = "refs/heads/master",
    )

def device_doctor_recipes():
    # Defines recipes
    luci.recipe(
        name = "cocoon/device_doctor",
        cipd_package = "flutter/recipe_bundles/flutter.googlesource.com/recipes",
        cipd_version = "refs/heads/master",
    )

def cocoon_try_config(platform_args):
    # Defines a list view for try builders
    list_view_name = "cocoon-try"
    luci.list_view(
        name = list_view_name,
        title = "Cocoon try builders",
    )

    # Defines cocoon linux try builders
    common.linux_try_builder(
        name = "Cocoon|cocoon",
        recipe = "cocoon",
        list_view_name = list_view_name,
        repo = repos.COCOON,
        add_cq = True,
        **platform_args["linux"]
    )
    common.linux_try_builder(
        name = "Linux device_doctor|device_doctor",
        recipe = "cocoon/device_doctor",
        list_view_name = list_view_name,
        repo = repos.COCOON,
        add_cq = True,
    )

    # Defines cocoon mac try builders
    common.mac_try_builder(
        name = "Mac device_doctor|device_doctor",
        recipe = "cocoon/device_doctor",
        list_view_name = list_view_name,
        repo = repos.COCOON,
        add_cq = True,
    )

    # Defines cocoon windows try builders
    common.windows_try_builder(
        name = "Windows device_doctor|device_doctor",
        recipe = "cocoon/device_doctor",
        list_view_name = list_view_name,
        repo = repos.COCOON,
        add_cq = True,
    )

cocoon_config = struct(setup = _setup)
