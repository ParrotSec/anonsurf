import os
import kill_apps_activities
import .. / ansurf_types


proc ansurf_do_kill_apps_cli(callback_send_messages: callback_send_messenger): int =
  const
    path_bleachbit = "/usr/bin/bleachbit"
  
  let kill_result = an_kill_apps()
  if kill_result != 0:
    callback_send_messages("Kill apps", "Some apps coudn't be killed", 1)
  
  if not fileExists(path_bleachbit):
    callback_send_messages("Kill apps", "Bleachbit is not found. Can't remove caches", 1)
  else:
    discard

  return kill_result


proc cli_kill_apps*(callback_send_msg: callback_send_messenger) =
  while true:
    echo("[?] Do you want to kill dangerous applications? (Y/n)")
    let input = readLine(stdin)
    if input == "y" or input == "Y":
      if ansurf_do_kill_apps_cli(callback_send_msg) == 0:
        callback_send_msg("Apps killer", "Success", 0)
      else:
        callback_send_msg("Apps killer", "Error while killing apps", 1)
    elif input == "n" or input == "N":
      return
    else:
      callback_send_msg("Apps killer", "Invalid option! Please use Y / N", 1)
