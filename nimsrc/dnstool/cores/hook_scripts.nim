import os
import dnstool_const
import .. / cli / print


proc hook_script_create_new(script_path, script_data: string) =
  if not fileExists(script_path):
    try:
      writeFile(script_path, script_data)
      setFilePermissions(script_path, {fpUserExec, fpUserRead, fpGroupExec, fpGroupRead, fpOthersRead, fpOthersExec})
    except:
      print_error("Failed to write hook script to " & script_path)


proc hook_script_remove_hook(script_path: string) =
  if fileExists(script_path):
    if not tryRemoveFile(script_path):
      print_error("Failed to remove hook script at " & script_path)


proc hook_script_init*() =
  hook_script_create_new(hook_script_dhcp_path, hook_script_dhcp_data)
  hook_script_create_new(hook_script_if_down_path, hook_script_if_down_data)
  hook_script_create_new(hook_script_if_up_path, hook_script_if_up_data)


proc hook_script_finit*() =
  hook_script_remove_hook(hook_script_dhcp_path)
  hook_script_remove_hook(hook_script_if_down_path)
  hook_script_remove_hook(hook_script_if_up_path)
