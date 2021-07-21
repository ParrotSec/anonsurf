

proc cli_kill_app*(): bool =
  while true:
    echo("[?] Do you want to kill dangerous applications? (Y/n)")
    let input = readLine(stdin)
    if input == "y" or input == "Y":
      return true
    elif input == "n" or input == "N":
      return false
    else:
      echo("Invalid option. Please use Y / n")


# proc gtk_kill_apps*() =
