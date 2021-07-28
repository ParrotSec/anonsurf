import net
import os
import activities / [boot, core_actions, extra_actions]


proc cmd_init_sudo*(isDesktop: bool): string =
  if isDesktop:
    return "gksudo"
  else:
    return "sudo"


proc cmd_handle_start*(sudo: string, callback_send_messages: proc) =
  if ansurf_core_start(sudo) == 0:
    callback_send_messages("AnonSurf Start", "AnonSurf started", 0)
  else:
    callback_send_messages("AnonSurf Start", "AnonSurf failed to start", 2)


proc cmd_handle_stop*(sudo: string, callback_send_messages: proc) =
  if ansurf_core_stop(sudo) == 0:
    callback_send_messages("AnonSurf Stop", "AnonSurf stopped", 0)
  else:
    callback_send_messages("AnonSurf Stop", "AnonSurf failed to stop", 2)


proc cmd_handle_status*() =
  let status = ansurf_core_status()
  # Expected program didn't start. We have to handle program exits / interrupted as well
  if status != 0:
    # TODO we have to show status of Tor, AnonDaemon, ports, DNS
    discard


proc cmd_handle_restart*(sudo: string, callback_send_messages: proc) =
  if ansurf_core_restart(sudo) == 0:
    callback_send_messages("AnonSurf Restart", "AnonSurf restarted", 0)
  else:
    callback_send_messages("AnonSurf Restart", "AnonSurf failed to restart", 2)


proc cmd_handle_boot_disable*(sudo: string, callback_send_messages: proc) =
  if ansurf_boot_disable(sudo) == 0:
    callback_send_messages("AnonSurf Disable Boot", "Disabled AnonSurf at boot", 0)
  else:
    callback_send_messages("AnonSurf Disable Boot", "Failed to disable AnonSurf at boot", 2)


proc cmd_handle_boot_enable*(sudo: string, callback_send_messages: proc) =
  if ansurf_boot_enable(sudo) == 0:
    callback_send_messages("AnonSurf Enable Boot", "Enabled AnonSurf at boot", 0)
  else:
    callback_send_messages("AnonSurf Enable Boot", "Failed to enable AnonSurf at boot", 2)


proc cmd_handle_boot_status*() =
  discard


proc cmd_handle_changeID*(callback_send_messages: proc) =
  let conf = "/etc/anonsurf/nyxrc"
  if fileExists(conf):
    try:
      let recvData = ansurf_extra_changeID(conf)
      if recvData[0] != "250 OK\c":
        callback_send_messages("ID Change", "Failed to change Identity. Error " & recvData[0], 2)
      else:
        if recvData[1] != "250 OK\c":
          callback_send_messages("ID Change", "Failed to change Identity. Error " & recvData[1], 2)
        else:
          # Success. Show okay
          callback_send_messages("ID Change", "You are having new identity", 0)
    except:
      callback_send_messages("ID Change", "Error while connecting to control port", 2)
      echo getCurrentExceptionMsg()
  else:
    callback_send_messages("ID Change", "Configuration file not found", 2)


proc cmd_handle_checkIP*(callback_send_messages: proc) =
  callback_send_messages("My IP", "Retrieving data from server", 3)
  let info = ansurf_extra_checkIP()
  # Error
  if info[0].startsWith("Error"):
    callback_send_messages("My IP", "Error while checking IP address", 2)
  # If program runs but user didn't connect to tor
  elif info[0].startsWith("Sorry"):
    callback_send_messages("My IP", "You are not under Tor network", 1)
  # Connected to tor
  else:
    callback_send_messages("My IP", "You are under Tor network", 0)
