

proc ansurf_cli_ask_killapps*(callback_send_messages: proc) =
  while true:
    echo("[?] Do you want to kill dangerous applications? (Y/n)")
    let input = readLine(stdin)
    if input == "y" or input == "Y":
      if an_kill_apps() == 0:
        callback_send_messages("Apps killer", "Success", 0)
      else:
        callback_send_messages("Apps killer", "Error while killing apps", 1)
    elif input == "n" or input == "N":
      return
    else:
      callback_send_messages("Apps killer", "Invalid option! Please use Y / N", 1)


proc ansurf_gtk_ask_killapps*() =
  discard