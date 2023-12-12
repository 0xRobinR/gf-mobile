//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <gf_sdk/gf_sdk_plugin_c_api.h>
#include <local_auth_windows/local_auth_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  GfSdkPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("GfSdkPluginCApi"));
  LocalAuthPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("LocalAuthPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
