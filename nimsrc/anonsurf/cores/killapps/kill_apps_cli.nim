import kill_apps_activities
import .. / ansurf_types


proc cli_kill_apps*(callback_send_msg: callback_send_messenger) =
  while true:
    echo("[?] Do you want to kill dangerous applications? (Y/n)")
    let input = readLine(stdin)
    if input == "y" or input == "Y":
      ansurf_kill_apps(callback_send_msg)
    elif input == "n" or input == "N":
      return
    else:
      callback_send_msg("Apps killer", "Invalid option! Please use Y / N", 1)
