# Copyright 2020 The Bazel Authors. All rights reserved.
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

"""Access Control Lists.

To create a new list:
  1. Create new .bzl file in the acls directory with a list of targets.
  2. Create matching method in this file.
  3. Add matching method to struct.

To check an ACL:
  1. Import the `acls` struct.
  2. Check `acls.list_name(fqn)` using the //fully/qualified:target

To update a list:
  1. Directly add/remove/edit targets in the appropriate .bzl file
"""

load("//rules/acls:aar_import_deps_checker.bzl", "AAR_IMPORT_DEPS_CHECKER_FALLBACK", "AAR_IMPORT_DEPS_CHECKER_ROLLOUT")
load("//rules/acls:aar_import_explicit_exports_manifest.bzl", "AAR_IMPORT_EXPLICIT_EXPORTS_MANIFEST")
load("//rules/acls:aar_import_exports_r_java.bzl", "AAR_IMPORT_EXPORTS_R_JAVA")
load("//rules/acls:aar_propagate_resources.bzl", "AAR_PROPAGATE_RESOURCES_FALLBACK", "AAR_PROPAGATE_RESOURCES_ROLLOUT")
load("//rules/acls:ait_install_snapshots.bzl", "APP_INSTALLATION_SNAPSHOT", "APP_INSTALLATION_SNAPSHOT_FALLBACK")
load("//rules/acls:allow_resource_conflicts.bzl", "ALLOW_RESOURCE_CONFLICTS")
load("//rules/acls:android_archive_dogfood.bzl", "ANDROID_ARCHIVE_DOGFOOD")
load("//rules/acls:android_archive_duplicate_class_allowlist.bzl", "ANDROID_ARCHIVE_DUPLICATE_CLASS_ALLOWLIST")
load("//rules/acls:android_archive_excluded_deps_denylist.bzl", "ANDROID_ARCHIVE_EXCLUDED_DEPS_DENYLIST")
load("//rules/acls:android_archive_exposed_package_allowlist.bzl", "ANDROID_ARCHIVE_EXPOSED_PACKAGE_ALLOWLIST")
load("//rules/acls:android_test_lockdown.bzl", "ANDROID_TEST_LOCKDOWN_GENERATOR_FUNCTIONS", "ANDROID_TEST_LOCKDOWN_TARGETS")
load("//rules/acls:android_device_plugin_rollout.bzl", "ANDROID_DEVICE_PLUGIN_FALLBACK", "ANDROID_DEVICE_PLUGIN_ROLLOUT")
load("//rules/acls:android_instrumentation_binary_starlark_resources.bzl", "ANDROID_INSTRUMENTATION_BINARY_STARLARK_RESOURCES_FALLBACK", "ANDROID_INSTRUMENTATION_BINARY_STARLARK_RESOURCES_ROLLOUT")
load("//rules/acls:android_binary_starlark_javac.bzl", "ANDROID_BINARY_STARLARK_JAVAC_FALLBACK", "ANDROID_BINARY_STARLARK_JAVAC_ROLLOUT")
load("//rules/acls:android_binary_starlark_split_transition.bzl", "ANDROID_BINARY_STARLARK_SPLIT_TRANSITION_FALLBACK", "ANDROID_BINARY_STARLARK_SPLIT_TRANSITION_ROLLOUT")
load("//rules/acls:android_feature_splits_dogfood.bzl", "ANDROID_FEATURE_SPLITS_DOGFOOD")
load("//rules/acls:android_library_resources_without_srcs.bzl", "ANDROID_LIBRARY_RESOURCES_WITHOUT_SRCS", "ANDROID_LIBRARY_RESOURCES_WITHOUT_SRCS_GENERATOR_FUNCTIONS")
load("//rules/acls:android_library_starlark_resource_outputs.bzl", "ANDROID_LIBRARY_STARLARK_RESOURCE_OUTPUTS_FALLBACK", "ANDROID_LIBRARY_STARLARK_RESOURCE_OUTPUTS_ROLLOUT")
load("//rules/acls:android_library_use_aosp_aidl_compiler.bzl", "ANDROID_LIBRARY_USE_AOSP_AIDL_COMPILER_ALLOWLIST")
load("//rules/acls:android_lint_checks_rollout.bzl", "ANDROID_LINT_CHECKS_FALLBACK", "ANDROID_LINT_CHECKS_ROLLOUT")
load("//rules/acls:android_lint_rollout.bzl", "ANDROID_LINT_FALLBACK", "ANDROID_LINT_ROLLOUT")
load("//rules/acls:lint_registry_rollout.bzl", "LINT_REGISTRY_FALLBACK", "LINT_REGISTRY_ROLLOUT")
load("//rules/acls:android_build_stamping_rollout.bzl", "ANDROID_BUILD_STAMPING_FALLBACK", "ANDROID_BUILD_STAMPING_ROLLOUT")
load("//rules/acls:b122039567.bzl", "B122039567")
load("//rules/acls:b123854163.bzl", "B123854163")
load("//rules/acls:dex2oat_opts.bzl", "CAN_USE_DEX2OAT_OPTIONS")
load("//rules/acls:fix_export_exporting_rollout.bzl", "FIX_EXPORT_EXPORTING_FALLBACK", "FIX_EXPORT_EXPORTING_ROLLOUT")
load("//rules/acls:fix_resource_transitivity_rollout.bzl", "FIX_RESOURCE_TRANSITIVITY_FALLBACK", "FIX_RESOURCE_TRANSITIVITY_ROLLOUT")
load("//rules/acls:host_dex2oat_rollout.bzl", "AIT_USE_HOST_DEX2OAT_ROLLOUT", "AIT_USE_HOST_DEX2OAT_ROLLOUT_FALLBACK")
load("//rules/acls:install_apps_in_data.bzl", "INSTALL_APPS_IN_DATA")
load("//rules/acls:local_test_multi_proto.bzl", "LOCAL_TEST_MULTI_PROTO_PKG")
load("//rules/acls:local_test_rollout.bzl", "LOCAL_TEST_FALLBACK", "LOCAL_TEST_ROLLOUT")
load("//rules/acls:local_test_starlark_resources.bzl", "LOCAL_TEST_STARLARK_RESOURCES_FALLBACK", "LOCAL_TEST_STARLARK_RESOURCES_ROLLOUT")
load("//rules/acls:android_test_platform_rollout.bzl", "ANDROID_TEST_PLATFORM_FALLBACK", "ANDROID_TEST_PLATFORM_ROLLOUT")
load("//rules/acls:sourceless_binary_rollout.bzl", "SOURCELESS_BINARY_FALLBACK", "SOURCELESS_BINARY_ROLLOUT")
load("//rules/acls:test_to_instrument_test_rollout.bzl", "TEST_TO_INSTRUMENT_TEST_FALLBACK", "TEST_TO_INSTRUMENT_TEST_ROLLOUT")
load(
    "//rules/acls:partial_jetification_targets.bzl",
    "PARTIAL_JETIFICATION_TARGETS_FALLBACK",
    "PARTIAL_JETIFICATION_TARGETS_ROLLOUT",
)
load("//rules/acls:kt_android_library_rollout.bzl", "KT_ANDROID_LIBRARY_FALLBACK", "KT_ANDROID_LIBRARY_ROLLOUT")
load("//rules/acls:android_instrumentation_test_manifest_check_rollout.bzl", "ANDROID_INSTRUMENTATION_TEST_MANIFEST_CHECK_FALLBACK", "ANDROID_INSTRUMENTATION_TEST_MANIFEST_CHECK_ROLLOUT")
load("//rules/acls:android_instrumentation_test_prebuilt_test_apk.bzl", "ANDROID_INSTRUMENTATION_TEST_PREBUILT_TEST_APK")
load("//rules/acls:android_rules_with_kt_rollout.bzl", "ANDROID_RULES_WITH_KT_FALLBACK", "ANDROID_RULES_WITH_KT_ROLLOUT")
load("//rules/acls:baseline_profiles_rollout.bzl", "BASELINE_PROFILES_ROLLOUT")
load("//rules/acls:enforce_min_sdk_floor_rollout.bzl", "ENFORCE_MIN_SDK_FLOOR_FALLBACK", "ENFORCE_MIN_SDK_FLOOR_ROLLOUT")
load("//rules/acls:android_apk_to_bundle_features_lockdown.bzl", "ANDROID_APK_TO_BUNDLE_FEATURES")

def _in_aar_import_deps_checker(fqn):
    return not matches(fqn, AAR_IMPORT_DEPS_CHECKER_FALLBACK_DICT) and matches(fqn, AAR_IMPORT_DEPS_CHECKER_ROLLOUT_DICT)

def _in_aar_import_explicit_exports_manifest(fqn):
    return matches(fqn, AAR_IMPORT_EXPLICIT_EXPORTS_MANIFEST_DICT)

def _in_aar_import_exports_r_java(fqn):
    return matches(fqn, AAR_IMPORT_EXPORTS_R_JAVA_DICT)

def _in_aar_propagate_resources(fqn):
    return not matches(fqn, AAR_PROPAGATE_RESOURCES_FALLBACK_DICT) and matches(fqn, AAR_PROPAGATE_RESOURCES_ROLLOUT_DICT)

def _in_android_archive_dogfood(fqn):
    return matches(fqn, ANDROID_ARCHIVE_DOGFOOD_DICT)

def _in_android_archive_excluded_deps_denylist(fqn):
    return matches(fqn, ANDROID_ARCHIVE_EXCLUDED_DEPS_DENYLIST_DICT)

def _in_android_device_plugin_rollout(fqn):
    return not matches(fqn, ANDROID_DEVICE_PLUGIN_FALLBACK_DICT) and matches(fqn, ANDROID_DEVICE_PLUGIN_ROLLOUT_DICT)

def _in_android_instrumentation_binary_starlark_resources(fqn):
    return not matches(fqn, ANDROID_INSTRUMENTATION_BINARY_STARLARK_RESOURCES_FALLBACK_DICT) and matches(fqn, ANDROID_INSTRUMENTATION_BINARY_STARLARK_RESOURCES_ROLLOUT_DICT)

def _in_android_binary_starlark_javac(fqn):
    return not matches(fqn, ANDROID_BINARY_STARLARK_JAVAC_FALLBACK_DICT) and matches(fqn, ANDROID_BINARY_STARLARK_JAVAC_ROLLOUT_DICT)

def _in_android_binary_starlark_split_transition(fqn):
    return not matches(fqn, ANDROID_BINARY_STARLARK_SPLIT_TRANSITION_FALLBACK_DICT) and matches(fqn, ANDROID_BINARY_STARLARK_SPLIT_TRANSITION_ROLLOUT_DICT)

def _in_android_feature_splits_dogfood(fqn):
    return matches(fqn, ANDROID_FEATURE_SPLITS_DOGFOOD_DICT)

def _in_android_lint_checks_rollout(fqn):
    return not matches(fqn, ANDROID_LINT_CHECKS_FALLBACK_DICT) and matches(fqn, ANDROID_LINT_CHECKS_ROLLOUT_DICT)

def _in_android_lint_rollout(fqn):
    return not matches(fqn, ANDROID_LINT_FALLBACK_DICT) and matches(fqn, ANDROID_LINT_ROLLOUT_DICT)

def _in_lint_registry_rollout(fqn):
    return not matches(fqn, LINT_REGISTRY_FALLBACK_DICT) and matches(fqn, LINT_REGISTRY_ROLLOUT_DICT)

def _in_android_build_stamping_rollout(fqn):
    return not matches(fqn, ANDROID_BUILD_STAMPING_FALLBACK_DICT) and matches(fqn, ANDROID_BUILD_STAMPING_ROLLOUT_DICT)

def _in_android_test_lockdown_allowlist(fqn, generator):
    if generator == "android_test":
        return matches(fqn, ANDROID_TEST_LOCKDOWN_TARGETS)
    return generator in ANDROID_TEST_LOCKDOWN_GENERATOR_FUNCTIONS_DICT

def _in_b122039567(fqn):
    return matches(fqn, B122039567_DICT)

def _in_b123854163(fqn):
    return matches(fqn, B123854163_DICT)

def _in_android_library_resources_without_srcs(fqn):
    return matches(fqn, ANDROID_LIBRARY_RESOURCES_WITHOUT_SRCS_DICT)

def _in_android_library_resources_without_srcs_generator_functions(gfn):
    return gfn in ANDROID_LIBRARY_RESOURCES_WITHOUT_SRCS_GENERATOR_FUNCTIONS_DICT

def _in_android_library_starlark_resource_outputs_rollout(fqn):
    return not matches(fqn, ANDROID_LIBRARY_STARLARK_RESOURCE_OUTPUTS_FALLBACK_DICT) and matches(fqn, ANDROID_LIBRARY_STARLARK_RESOURCE_OUTPUTS_ROLLOUT_DICT)

def _in_android_library_use_aosp_aidl_compiler_allowlist(fqn):
    return matches(fqn, ANDROID_LIBRARY_USE_AOSP_AIDL_COMPILER_ALLOWLIST_DICT)

def _in_app_installation_snapshot(fqn):
    return not matches(fqn, APP_INSTALLATION_SNAPSHOT_FALLBACK_DICT) and matches(fqn, APP_INSTALLATION_SNAPSHOT_DICT)

def _in_dex2oat_opts(fqn):
    return matches(fqn, CAN_USE_DEX2OAT_OPTIONS_DICT)

def _in_fix_export_exporting_rollout(fqn):
    return not matches(fqn, FIX_EXPORT_EXPORTING_FALLBACK_DICT) and matches(fqn, FIX_EXPORT_EXPORTING_ROLLOUT_DICT)

def _in_fix_resource_transivity_rollout(fqn):
    return not matches(fqn, FIX_RESOURCE_TRANSIVITY_FALLBACK_DICT) and matches(fqn, FIX_RESOURCE_TRANSIVITY_ROLLOUT_DICT)

def _in_host_dex2oat_rollout(fqn):
    return not matches(fqn, AIT_USE_HOST_DEX2OAT_ROLLOUT_FALLBACK_DICT) and matches(fqn, AIT_USE_HOST_DEX2OAT_ROLLOUT_DICT)

def _in_install_apps_in_data(fqn):
    return matches(fqn, AIT_INSTALL_APPS_IN_DATA_DICT)

def _in_local_test_multi_proto(fqn):
    return matches(fqn, LOCAL_TEST_MULTI_PROTO_PKG_DICT)

def _in_local_test_rollout(fqn):
    return not matches(fqn, LOCAL_TEST_FALLBACK_DICT) and matches(fqn, LOCAL_TEST_ROLLOUT_DICT)

def _in_local_test_starlark_resources(fqn):
    return not matches(fqn, LOCAL_TEST_STARLARK_RESOURCES_FALLBACK_DICT) and matches(fqn, LOCAL_TEST_STARLARK_RESOURCES_ROLLOUT_DICT)

def _in_android_test_platform_rollout(fqn):
    return not matches(fqn, ANDROID_TEST_PLATFORM_FALLBACK_DICT) and matches(fqn, ANDROID_TEST_PLATFORM_ROLLOUT_DICT)

def _in_sourceless_binary_rollout(fqn):
    return not matches(fqn, SOURCELESS_BINARY_FALLBACK_DICT) and matches(fqn, SOURCELESS_BINARY_ROLLOUT_DICT)

def _in_test_to_instrument_test_rollout(fqn):
    return not matches(fqn, TEST_TO_INSTRUMENT_TEST_FALLBACK_DICT) and matches(fqn, TEST_TO_INSTRUMENT_TEST_ROLLOUT_DICT)

def _in_allow_resource_conflicts(fqn):
    return matches(fqn, ALLOW_RESOURCE_CONFLICTS_DICT)

def _in_partial_jetification_targets(fqn):
    return not matches(fqn, PARTIAL_JETIFICATION_TARGETS_FALLBACK_DICT) and matches(fqn, PARTIAL_JETIFICATION_TARGETS_ROLLOUT_DICT)

def _in_kt_android_library_rollout(fqn):
    return not matches(fqn, KT_ANDROID_LIBRARY_FALLBACK_DICT) and matches(fqn, KT_ANDROID_LIBRARY_ROLLOUT_DICT)

def _in_android_instrumentation_test_manifest_check_rollout(fqn):
    return not matches(fqn, ANDROID_INSTRUMENTATION_TEST_MANIFEST_CHECK_FALLBACK_DICT) and matches(fqn, ANDROID_INSTRUMENTATION_TEST_MANIFEST_CHECK_ROLLOUT_DICT)

def _in_android_instrumentation_test_prebuilt_test_apk(fqn):
    return matches(fqn, ANDROID_INSTRUMENTATION_TEST_PREBUILT_TEST_APK_DICT)

def _in_android_rules_with_kt_rollout(fqn):
    return not matches(fqn, ANDROID_RULES_WITH_KT_FALLBACK_DICT) and matches(fqn, ANDROID_RULES_WITH_KT_ROLLOUT_DICT)

def _get_android_archive_exposed_package_allowlist(fqn):
    return ANDROID_ARCHIVE_EXPOSED_PACKAGE_ALLOWLIST.get(fqn, [])

def _in_baseline_profiles_rollout(fqn):
    return matches(fqn, BASELINE_PROFILES_ROLLOUT)

def _in_enforce_min_sdk_floor_rollout(fqn):
    return not matches(fqn, ENFORCE_MIN_SDK_FLOOR_FALLBACK_DICT) and matches(fqn, ENFORCE_MIN_SDK_FLOOR_ROLLOUT_DICT)

def _in_android_apk_to_bundle_features(fqn):
    return matches(fqn, ANDROID_APK_TO_BUNDLE_FEATURES_DICT)

def _get_android_archive_duplicate_class_allowlist(fqn):
    return ANDROID_ARCHIVE_DUPLICATE_CLASS_ALLOWLIST.get(fqn, [])

def make_dict(lst):
    """Do not use this method outside of acls directory."""
    return {t: True for t in lst}

AAR_IMPORT_DEPS_CHECKER_FALLBACK_DICT = make_dict(AAR_IMPORT_DEPS_CHECKER_FALLBACK)
AAR_IMPORT_DEPS_CHECKER_ROLLOUT_DICT = make_dict(AAR_IMPORT_DEPS_CHECKER_ROLLOUT)
AAR_IMPORT_EXPLICIT_EXPORTS_MANIFEST_DICT = make_dict(AAR_IMPORT_EXPLICIT_EXPORTS_MANIFEST)
AAR_IMPORT_EXPORTS_R_JAVA_DICT = make_dict(AAR_IMPORT_EXPORTS_R_JAVA)
AAR_PROPAGATE_RESOURCES_FALLBACK_DICT = make_dict(AAR_PROPAGATE_RESOURCES_FALLBACK)
AAR_PROPAGATE_RESOURCES_ROLLOUT_DICT = make_dict(AAR_PROPAGATE_RESOURCES_ROLLOUT)
ANDROID_ARCHIVE_DOGFOOD_DICT = make_dict(ANDROID_ARCHIVE_DOGFOOD)
ANDROID_ARCHIVE_EXCLUDED_DEPS_DENYLIST_DICT = make_dict(ANDROID_ARCHIVE_EXCLUDED_DEPS_DENYLIST)
ANDROID_DEVICE_PLUGIN_ROLLOUT_DICT = make_dict(ANDROID_DEVICE_PLUGIN_ROLLOUT)
ANDROID_DEVICE_PLUGIN_FALLBACK_DICT = make_dict(ANDROID_DEVICE_PLUGIN_FALLBACK)
ANDROID_INSTRUMENTATION_BINARY_STARLARK_RESOURCES_ROLLOUT_DICT = make_dict(ANDROID_INSTRUMENTATION_BINARY_STARLARK_RESOURCES_ROLLOUT)
ANDROID_INSTRUMENTATION_BINARY_STARLARK_RESOURCES_FALLBACK_DICT = make_dict(ANDROID_INSTRUMENTATION_BINARY_STARLARK_RESOURCES_FALLBACK)
ANDROID_BINARY_STARLARK_JAVAC_ROLLOUT_DICT = make_dict(ANDROID_BINARY_STARLARK_JAVAC_ROLLOUT)
ANDROID_BINARY_STARLARK_JAVAC_FALLBACK_DICT = make_dict(ANDROID_BINARY_STARLARK_JAVAC_FALLBACK)
ANDROID_BINARY_STARLARK_SPLIT_TRANSITION_ROLLOUT_DICT = make_dict(ANDROID_BINARY_STARLARK_SPLIT_TRANSITION_ROLLOUT)
ANDROID_BINARY_STARLARK_SPLIT_TRANSITION_FALLBACK_DICT = make_dict(ANDROID_BINARY_STARLARK_SPLIT_TRANSITION_FALLBACK)
ANDROID_FEATURE_SPLITS_DOGFOOD_DICT = make_dict(ANDROID_FEATURE_SPLITS_DOGFOOD)
ANDROID_LIBRARY_RESOURCES_WITHOUT_SRCS_DICT = make_dict(ANDROID_LIBRARY_RESOURCES_WITHOUT_SRCS)
ANDROID_LIBRARY_RESOURCES_WITHOUT_SRCS_GENERATOR_FUNCTIONS_DICT = make_dict(ANDROID_LIBRARY_RESOURCES_WITHOUT_SRCS_GENERATOR_FUNCTIONS)
ANDROID_LIBRARY_STARLARK_RESOURCE_OUTPUTS_FALLBACK_DICT = make_dict(ANDROID_LIBRARY_STARLARK_RESOURCE_OUTPUTS_FALLBACK)
ANDROID_LIBRARY_STARLARK_RESOURCE_OUTPUTS_ROLLOUT_DICT = make_dict(ANDROID_LIBRARY_STARLARK_RESOURCE_OUTPUTS_ROLLOUT)
ANDROID_LINT_CHECKS_FALLBACK_DICT = make_dict(ANDROID_LINT_CHECKS_FALLBACK)
ANDROID_LINT_CHECKS_ROLLOUT_DICT = make_dict(ANDROID_LINT_CHECKS_ROLLOUT)
ANDROID_LINT_FALLBACK_DICT = make_dict(ANDROID_LINT_FALLBACK)
ANDROID_LINT_ROLLOUT_DICT = make_dict(ANDROID_LINT_ROLLOUT)
ANDROID_RULES_WITH_KT_ROLLOUT_DICT = make_dict(ANDROID_RULES_WITH_KT_ROLLOUT)
ANDROID_RULES_WITH_KT_FALLBACK_DICT = make_dict(ANDROID_RULES_WITH_KT_FALLBACK)

LINT_REGISTRY_FALLBACK_DICT = make_dict(LINT_REGISTRY_FALLBACK)
LINT_REGISTRY_ROLLOUT_DICT = make_dict(LINT_REGISTRY_ROLLOUT)
ANDROID_BUILD_STAMPING_ROLLOUT_DICT = make_dict(ANDROID_BUILD_STAMPING_ROLLOUT)
ANDROID_BUILD_STAMPING_FALLBACK_DICT = make_dict(ANDROID_BUILD_STAMPING_FALLBACK)
ANDROID_TEST_LOCKDOWN_GENERATOR_FUNCTIONS_DICT = make_dict(ANDROID_TEST_LOCKDOWN_GENERATOR_FUNCTIONS)
ANDROID_TEST_LOCKDOWN_TARGETS_DICT = make_dict(ANDROID_TEST_LOCKDOWN_TARGETS)
APP_INSTALLATION_SNAPSHOT_DICT = make_dict(APP_INSTALLATION_SNAPSHOT)
APP_INSTALLATION_SNAPSHOT_FALLBACK_DICT = make_dict(APP_INSTALLATION_SNAPSHOT_FALLBACK)
B122039567_DICT = make_dict(B122039567)
B123854163_DICT = make_dict(B123854163)
CAN_USE_DEX2OAT_OPTIONS_DICT = make_dict(CAN_USE_DEX2OAT_OPTIONS)
FIX_RESOURCE_TRANSIVITY_FALLBACK_DICT = make_dict(FIX_RESOURCE_TRANSITIVITY_FALLBACK)
FIX_RESOURCE_TRANSIVITY_ROLLOUT_DICT = make_dict(FIX_RESOURCE_TRANSITIVITY_ROLLOUT)
FIX_EXPORT_EXPORTING_FALLBACK_DICT = make_dict(FIX_EXPORT_EXPORTING_FALLBACK)
FIX_EXPORT_EXPORTING_ROLLOUT_DICT = make_dict(FIX_EXPORT_EXPORTING_ROLLOUT)
AIT_USE_HOST_DEX2OAT_ROLLOUT_DICT = make_dict(AIT_USE_HOST_DEX2OAT_ROLLOUT)
AIT_USE_HOST_DEX2OAT_ROLLOUT_FALLBACK_DICT = make_dict(AIT_USE_HOST_DEX2OAT_ROLLOUT_FALLBACK)
AIT_INSTALL_APPS_IN_DATA_DICT = make_dict(INSTALL_APPS_IN_DATA)
LOCAL_TEST_MULTI_PROTO_PKG_DICT = make_dict(LOCAL_TEST_MULTI_PROTO_PKG)
LOCAL_TEST_FALLBACK_DICT = make_dict(LOCAL_TEST_FALLBACK)
LOCAL_TEST_ROLLOUT_DICT = make_dict(LOCAL_TEST_ROLLOUT)
LOCAL_TEST_STARLARK_RESOURCES_FALLBACK_DICT = make_dict(LOCAL_TEST_STARLARK_RESOURCES_FALLBACK)
LOCAL_TEST_STARLARK_RESOURCES_ROLLOUT_DICT = make_dict(LOCAL_TEST_STARLARK_RESOURCES_ROLLOUT)
ANDROID_TEST_PLATFORM_FALLBACK_DICT = make_dict(ANDROID_TEST_PLATFORM_FALLBACK)
ANDROID_TEST_PLATFORM_ROLLOUT_DICT = make_dict(ANDROID_TEST_PLATFORM_ROLLOUT)
SOURCELESS_BINARY_FALLBACK_DICT = make_dict(SOURCELESS_BINARY_FALLBACK)
SOURCELESS_BINARY_ROLLOUT_DICT = make_dict(SOURCELESS_BINARY_ROLLOUT)
TEST_TO_INSTRUMENT_TEST_FALLBACK_DICT = make_dict(TEST_TO_INSTRUMENT_TEST_FALLBACK)
TEST_TO_INSTRUMENT_TEST_ROLLOUT_DICT = make_dict(TEST_TO_INSTRUMENT_TEST_ROLLOUT)
ALLOW_RESOURCE_CONFLICTS_DICT = make_dict(ALLOW_RESOURCE_CONFLICTS)
PARTIAL_JETIFICATION_TARGETS_ROLLOUT_DICT = make_dict(PARTIAL_JETIFICATION_TARGETS_ROLLOUT)
PARTIAL_JETIFICATION_TARGETS_FALLBACK_DICT = make_dict(PARTIAL_JETIFICATION_TARGETS_FALLBACK)
KT_ANDROID_LIBRARY_ROLLOUT_DICT = make_dict(KT_ANDROID_LIBRARY_ROLLOUT)
KT_ANDROID_LIBRARY_FALLBACK_DICT = make_dict(KT_ANDROID_LIBRARY_FALLBACK)
ANDROID_INSTRUMENTATION_TEST_MANIFEST_CHECK_ROLLOUT_DICT = make_dict(ANDROID_INSTRUMENTATION_TEST_MANIFEST_CHECK_ROLLOUT)
ANDROID_INSTRUMENTATION_TEST_MANIFEST_CHECK_FALLBACK_DICT = make_dict(ANDROID_INSTRUMENTATION_TEST_MANIFEST_CHECK_FALLBACK)
ANDROID_INSTRUMENTATION_TEST_PREBUILT_TEST_APK_DICT = make_dict(ANDROID_INSTRUMENTATION_TEST_PREBUILT_TEST_APK)
BASELINE_PROFILES_ROLLOUT_DICT = make_dict(BASELINE_PROFILES_ROLLOUT)
ENFORCE_MIN_SDK_FLOOR_ROLLOUT_DICT = make_dict(ENFORCE_MIN_SDK_FLOOR_ROLLOUT)
ENFORCE_MIN_SDK_FLOOR_FALLBACK_DICT = make_dict(ENFORCE_MIN_SDK_FLOOR_FALLBACK)
ANDROID_APK_TO_BUNDLE_FEATURES_DICT = make_dict(ANDROID_APK_TO_BUNDLE_FEATURES)
ANDROID_LIBRARY_USE_AOSP_AIDL_COMPILER_ALLOWLIST_DICT = make_dict(ANDROID_LIBRARY_USE_AOSP_AIDL_COMPILER_ALLOWLIST)

def matches(fqn, dct):
    # Labels with workspace names ("@workspace//pkg:target") are not supported.
    if fqn.startswith("@"):
        return False

    if not fqn.startswith("//"):
        fail("Fully qualified target should start with '//', got: " + fqn)

    if fqn in dct:
        return True

    pkg_and_target = fqn.split(":")
    if len(pkg_and_target) != 2:
        fail("Expected fully qualified target, got: " + fqn)
    pkg = pkg_and_target[0]

    if (pkg + ":__pkg__") in dct:
        return True

    pkg = pkg.lstrip("//")
    pkg_parts = pkg.split("/")
    ancestor_pkg = "//"

    if (ancestor_pkg + ":__subpackages__") in dct:
        return True

    for pkg_part in pkg_parts:
        ancestor_pkg = (
            (ancestor_pkg + "/" + pkg_part) if ancestor_pkg != "//" else ("//" + pkg_part)
        )
        if (ancestor_pkg + ":__subpackages__") in dct:
            return True

    return False

acls = struct(
    get_android_archive_duplicate_class_allowlist = _get_android_archive_duplicate_class_allowlist,
    get_android_archive_exposed_package_allowlist = _get_android_archive_exposed_package_allowlist,
    in_aar_import_deps_checker = _in_aar_import_deps_checker,
    in_aar_import_explicit_exports_manifest = _in_aar_import_explicit_exports_manifest,
    in_aar_import_exports_r_java = _in_aar_import_exports_r_java,
    in_aar_propagate_resources = _in_aar_propagate_resources,
    in_b122039567 = _in_b122039567,
    in_b123854163 = _in_b123854163,
    in_android_archive_dogfood = _in_android_archive_dogfood,
    in_android_archive_excluded_deps_denylist = _in_android_archive_excluded_deps_denylist,
    in_android_device_plugin_rollout = _in_android_device_plugin_rollout,
    in_android_instrumentation_binary_starlark_resources = _in_android_instrumentation_binary_starlark_resources,
    in_android_binary_starlark_javac = _in_android_binary_starlark_javac,
    in_android_binary_starlark_split_transition = _in_android_binary_starlark_split_transition,
    in_android_feature_splits_dogfood = _in_android_feature_splits_dogfood,
    in_android_library_starlark_resource_outputs_rollout = _in_android_library_starlark_resource_outputs_rollout,
    in_android_library_resources_without_srcs = _in_android_library_resources_without_srcs,
    in_android_library_resources_without_srcs_generator_functions = _in_android_library_resources_without_srcs_generator_functions,
    in_android_library_use_aosp_aidl_compiler_allowlist = _in_android_library_use_aosp_aidl_compiler_allowlist,
    in_android_lint_checks_rollout = _in_android_lint_checks_rollout,
    in_android_lint_rollout = _in_android_lint_rollout,
    in_lint_registry_rollout = _in_lint_registry_rollout,
    in_android_build_stamping_rollout = _in_android_build_stamping_rollout,
    in_android_test_lockdown_allowlist = _in_android_test_lockdown_allowlist,
    in_app_installation_snapshot = _in_app_installation_snapshot,
    in_dex2oat_opts = _in_dex2oat_opts,
    in_fix_export_exporting_rollout = _in_fix_export_exporting_rollout,
    in_fix_resource_transivity_rollout = _in_fix_resource_transivity_rollout,
    in_host_dex2oat_rollout = _in_host_dex2oat_rollout,
    in_install_apps_in_data = _in_install_apps_in_data,
    in_local_test_multi_proto = _in_local_test_multi_proto,
    in_local_test_rollout = _in_local_test_rollout,
    in_local_test_starlark_resources = _in_local_test_starlark_resources,
    in_android_test_platform_rollout = _in_android_test_platform_rollout,
    in_sourceless_binary_rollout = _in_sourceless_binary_rollout,
    in_test_to_instrument_test_rollout = _in_test_to_instrument_test_rollout,
    in_allow_resource_conflicts = _in_allow_resource_conflicts,
    in_partial_jetification_targets = _in_partial_jetification_targets,
    in_kt_android_library_rollout = _in_kt_android_library_rollout,
    in_android_instrumentation_test_manifest_check_rollout = _in_android_instrumentation_test_manifest_check_rollout,
    in_android_instrumentation_test_prebuilt_test_apk = _in_android_instrumentation_test_prebuilt_test_apk,
    in_android_rules_with_kt_rollout = _in_android_rules_with_kt_rollout,
    in_baseline_profiles_rollout = _in_baseline_profiles_rollout,
    in_enforce_min_sdk_floor_rollout = _in_enforce_min_sdk_floor_rollout,
    in_android_apk_to_bundle_features = _in_android_apk_to_bundle_features,
)

# Visible for testing
testing = struct(
    matches = matches,
    make_dict = make_dict,
)
