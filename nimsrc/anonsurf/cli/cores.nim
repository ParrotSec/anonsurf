import os
import osproc
import .. / displays / noti
import print

let isDesktop* = if getEnv("XDG_CURRENT_DESKTOP") == "": false else: true


proc runOSCommand*(command, commandName: string) =
  var cmdResult: int
  if isDesktop:
    cmdResult = execCmd("gksudo " & command)
    if cmdResult == 0:
      sendNotify("AnonSurf", commandName & " success", "security-high")
    else:
      sendNotify("AnonSurf", commandName & " failed", "error")
  else:
    cmdResult = execCmd("sudo " & command)
    if cmdResult == 0:
      msgOk(commandName & " success")
    else:
      msgErr(commandName & " failed")


proc cliUserAsk*(): bool =
  while true:
    echo "[?] Do you want to kill dangerous applications? (Y/n)"
    let input = readLine(stdin)
    if input == "y" or input == "Y":
      return true
    elif input == "n" or input == "N":
      return false
    else:
      msgWarn("Invalid option. Please use Y / n")
