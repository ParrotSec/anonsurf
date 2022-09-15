import net
import os
import activities / [boot_actions, core_actions, extra_actions, messages]
import commons / [services_status, ansurf_objects]
import strutils


proc cmd_init_sudo*(isDesktop: bool): string =
  if isDesktop:
    let menuexecPath = findExe("menuexecg")
    if not isEmptyOrWhitespace(menuexecPath):
      return menuexecPath
    else:
      return "pkexec env DISPLAY=\"$DISPLAY\" XAUTHORITY=\"$XAUTHORITY\" "
  else:
    return "sudo"


proc cli_init_callback_msg*(isDesktop: bool): callback_send_messenger =
  if isDesktop:
    return gtk_send_msg
  else:
    return cli_send_msg


proc ansurf_acts_handle_start*(sudo: string, callback_send_messages: callback_send_messenger) =
  let status_start_surf = ansurf_core_start(sudo)
  if status_start_surf == 0:
    if getServStatus("anonsurfd"):
      callback_send_messages("AnonSurf Status", "AnonSurf is running", SecurityHigh)
      if getServStatus("tor"):
        callback_send_messages("Tor Status", "Tor is running", SecurityHigh)
      else:
        callback_send_messages("Tor Status", "Tor is not running", SecurityLow)
    else:
      callback_send_messages("AnonSurf Status", "AnonSurf failed to start", SecurityLow)
  elif status_start_surf == 255:
    callback_send_messages("AnonSurf Start", "Cancelled by user", SecurityLow)
  else:
    callback_send_messages("AnonSurf Start", "AnonSurf failed to start", SecurityLow)


proc ansurf_acts_handle_stop*(sudo: string, callback_send_messages: callback_send_messenger) =
  let stop_status = ansurf_core_stop(sudo)
  if stop_status == 0:
    callback_send_messages("AnonSurf Stop", "AnonSurf stopped", SecurityHigh)
  elif stop_status == 255:
    discard
  else:
    callback_send_messages("AnonSurf Stop", "AnonSurf failed to stop", SecurityLow)


proc ansurf_acts_handle_restart*(sudo: string, callback_send_messages: callback_send_messenger) =
  if not getServStatus("anonsurfd"):
    callback_send_messages("AnonSurf Status", "AnonSurf is not running. Can't restart it", SecurityLow)
    return
  let restart_result = ansurf_core_restart(sudo)
  if restart_result == 0:
    if getServStatus("anonsurfd"):
      callback_send_messages("AnonSurf Status", "AnonSurf is restarted", SecurityHigh)
    else:
      callback_send_messages("AnonSurf Status", "AnonSurf failed to start", SecurityLow)
  elif restart_result == 255:
    discard
  else:
    callback_send_messages("AnonSurf Restart", "AnonSurf failed to restart", SecurityLow)


proc ansurf_acts_handle_boot_disable*(sudo: string, callback_send_messages: callback_send_messenger) =
  if not isServEnabled("anonsurfd.service"):
    callback_send_messages("AnonSurf disable boot", "AnonSurf is already disabled!", SecurityMedium)
    return
  if ansurf_boot_disable(sudo) == 0:
    callback_send_messages("AnonSurf Disable Boot", "Disabled AnonSurf at boot", SecurityHigh)
  else:
    callback_send_messages("AnonSurf Disable Boot", "Failed to disable AnonSurf at boot", SecurityLow)


proc ansurf_acts_handle_boot_enable*(sudo: string, callback_send_messages: callback_send_messenger) =
  if isServEnabled("anonsurfd.service"):
    callback_send_messages("AnonSurf disable boot", "AnonSurf is already enabled!", SecurityMedium)
    return
  if ansurf_boot_enable(sudo) == 0:
    callback_send_messages("AnonSurf Enable Boot", "Enabled AnonSurf at boot", SecurityHigh)
  else:
    callback_send_messages("AnonSurf Enable Boot", "Failed to enable AnonSurf at boot", SecurityLow)


proc ansurf_acts_handle_changeID*(callback_send_messages: callback_send_messenger) =
  if not getServStatus("anonsurfd"):
    callback_send_messages("AnonSurf Status", "AnonSurf is not running", SecurityLow)
    return

  let conf = "/etc/anonsurf/nyxrc"
  if fileExists(conf):
    try:
      let recvData = ansurf_extra_changeID(conf)
      if recvData[0] != "250 OK\c":
        callback_send_messages("ID Change", "Failed to change Identity. Error " & recvData[0], SecurityLow)
      else:
        if recvData[1] != "250 OK\c":
          callback_send_messages("ID Change", "Failed to change Identity. Error " & recvData[1], SecurityLow)
        else:
          # Success. Show okay
          callback_send_messages("ID Change", "You are having new identity", SecurityHigh)
    except:
      callback_send_messages("ID Change", "Error while connecting to control port", SecurityLow)
      echo getCurrentExceptionMsg()
  else:
    callback_send_messages("ID Change", "Configuration file not found", SecurityLow)


proc ansurf_acts_handle_checkIP*(callback_send_messages: callback_send_messenger) =
  callback_send_messages("My IP", "Retrieving data from server", SecurityInfo)
  let info = ansurf_extra_checkIP()
  # Error
  if info[0].startsWith("Error"):
    callback_send_messages("My IP", "Error while checking IP address", SecurityLow)
  # If program runs but user didn't connect to tor
  elif info[0].startsWith("Sorry"):
    callback_send_messages(info[1], "You are not under Tor network", SecurityMedium)
  # Connected to tor
  else:
    callback_send_messages(info[1], "You are under Tor network", SecurityHigh)
