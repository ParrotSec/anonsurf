import os

let isDesktop* = if getEnv("XDG_CURRENT_DESKTOP") == "": false else: true


proc cliUserAsk*(): bool =
  while true:
    echo "[?] Do you want to kill dangerous applications? (Y/n)"
    let input = readLine(stdin)
    if input == "y" or input == "Y":
      return true
    elif input == "n" or input == "N":
      return false
    else:
      echo("Invalid option. Please use Y / n")
