import strutils
import osproc
import os
import modules / [myip, changeid]
import cores / services
import cli / [help, killapp]
import cores / [messengers, surf_commands]

let
  isDesktop = if getEnv("XDG_CURRENT_DESKTOP") == "": false else: true
  callback_msg_proc = cli_init_callback_msg(isDesktop)
  sudo = cli_init_sudo(isDesktop)


proc checkIP() =
  callback_send_msg(callback_msg_proc, "My IP", "Retrieving data from server", 3)
  let info = checkIPFromTorServer()
  # Error
  if info[0].startsWith("Error"):
    callback_send_msg(callback_msg_proc, "My IP", "Error while checking IP address", 2)
  # If program runs but user didn't connect to tor
  elif info[0].startsWith("Sorry"):
    callback_send_msg(callback_msg_proc, "My IP", "You are not under Tor network", 1)
  # Connected to tor
  else:
    callback_send_msg(callback_msg_proc, "My IP", "You are under Tor network", 0)


proc killApps() =
  let killResult = doKillAppsFromCli()
  if killResult == 0:
    callback_send_msg(callback_msg_proc, "Kill apps", "Dangerous applications are killed", 0)
  elif killResult != -1:
    callback_send_msg(callback_msg_proc, "Kill apps", "Error while trying to kill applications", 1)

proc start() =
  # start daemon
  # Check if all services are started
  
  if not checkInitSystem():
    callback_send_msg(callback_msg_proc, "System check", "No system init is running", 2)
    return

  if getServStatus("anonsurfd") == 0:
    callback_send_msg(callback_msg_proc, "AnonSurf Status", "AnonSurf is started already", 1)
    return

  killApps()
  cli_handle_start(sudo, callback_msg_proc)

  # Check AnonSurf Daemon status after start
  # TODO maybe better complex check
  if getServStatus("anonsurfd") == 0:
    callback_send_msg(callback_msg_proc, "AnonSurf Status", "AnonSurf is running", 0)
    if getServStatus("tor") == 0:
      callback_send_msg(callback_msg_proc, "Tor Status", "Tor is running", 0)
    else:
      callback_send_msg(callback_msg_proc, "Tor Status", "Tor is not running", 2)
  else:
    callback_send_msg(callback_msg_proc, "AnonSurf Status", "AnonSurf failed to start", 2)


proc stop() =
  # stop daemon
  # show notifi
  
  if not checkInitSystem():
    callback_send_msg(callback_msg_proc, "System check", "No system init is running", 2)
    return

  if getServStatus("anonsurfd") != 0:
    callback_send_msg(callback_msg_proc, "AnonSurf Status", "AnonSurf is not running", 1)
    return

  cli_handle_stop(sudo, callback_msg_proc)
  killApps()


proc restart() =  
  if not checkInitSystem():
    callback_send_msg(callback_msg_proc, "System check", "No system init is running", 2)
    return

  if getServStatus("anonsurfd") != 0:
    callback_send_msg(callback_msg_proc, "AnonSurf Status", "AnonSurf is not running", 1)
    return

  cli_handle_restart(sudo, callback_msg_proc)

  if getServStatus("anonsurfd") == 0:
    callback_send_msg(callback_msg_proc, "AnonSurf Status", "AnonSurf is running", 0)
    if getServStatus("tor") == 0:
      callback_send_msg(callback_msg_proc, "Tor Status", "Tor is running", 0)
    else:
      callback_send_msg(callback_msg_proc, "Tor Status", "Tor is not running", 2)
  else:
    callback_send_msg(callback_msg_proc, "AnonSurf Status", "AnonSurf failed to restart", 2)


proc checkBoot() =
  # no launcher. No send notify
  # check if it is started with boot and show popup
  if not checkInitSystem():
    callback_send_msg(callback_msg_proc, "System check", "No system init is running", 2)
    return

  let bootResult = isServEnabled("anonsurfd.service")
  if bootResult:
    callback_send_msg(callback_msg_proc, "Startup check", "AnonSurf is enabled at boot", 0)
  else:
    callback_send_msg(callback_msg_proc, "Startup check", "AnonSurf is not enabled at boot", 0)


proc enableBoot() =
  if not checkInitSystem():
    callback_send_msg(callback_msg_proc, "System check", "No system init is running", 2)
    return

  # enable anosnurf at boot (systemd only for now)
  if isServEnabled("anonsurfd.service"):
    callback_send_msg(callback_msg_proc, "Startup check", "AnonSurf is already enabled!", 1)
  else:
    cli_handle_enable(sudo, callback_msg_proc)
    checkBoot()


proc disableBoot() =
  if not checkInitSystem():
    callback_send_msg(callback_msg_proc, "System check", "No system init is running", 2)
    return

  if not isServEnabled("anonsurfd.service"):
    callback_send_msg(callback_msg_proc, "Startup check", "AnonSurf is already disabled!", 1)
  else:
    cli_handle_disable(sudo, callback_msg_proc)
    checkBoot()


proc changeID() =
  if not checkInitSystem():
    callback_send_msg(callback_msg_proc, "System check", "No system init is running", 2)
    return
  # change id just like gui
  if getServStatus("anonsurfd") != 0:
    callback_send_msg(callback_msg_proc, "AnonSurf Status", "AnonSurf is not running", 2)
    return
  
  let conf = "/etc/anonsurf/nyxrc"
  if fileExists(conf):
    try:
      let recvData = doChangeID(conf)
      if recvData[0] != "250 OK\c":
        if isDesktop:
          callback_send_msg(callback_msg_proc, "ID Change", "Failed to change Identity. Error " & recvData[0], 2)
      else:
        if recvData[1] != "250 OK\c":
          callback_send_msg(callback_msg_proc, "ID Change", "Failed to change Identity. Error " & recvData[1], 2)
        else:
          # Success. Show okay
          callback_send_msg(callback_msg_proc, "ID Change", "You are having new identity", 0)
    except:
      callback_send_msg(callback_msg_proc, "ID Change", "Error while connecting to control port", 2)
      echo getCurrentExceptionMsg()
  else:
    callback_send_msg(callback_msg_proc, "ID Change", "Configuration file not found", 2)


proc status() =
  # Show nyx
  if not checkInitSystem():
    callback_send_msg(callback_msg_proc, "System check", "No system init is running", 2)
    return
  
  if getServStatus("anonsurfd") != 0:
    callback_send_msg(callback_msg_proc, "AnonSurf Status", "AnonSurf is not running", 2)
  else:
    if not fileExists("/etc/anonsurf/nyxrc"):
      callback_send_msg(callback_msg_proc, "AnonSurf Status", "Nyxrc is not found", 0)
    else:
      discard execCmd("/usr/bin/nyx --config /etc/anonsurf/nyxrc")


proc checkOptions() =
  if paramCount() != 1:
    devBanner()
    helpBanner()
  else:
    case paramStr(1)
    of "start":
      start()
    of "stop":
      stop()
    of "restart":
      restart()
    of "status":
      status()
    of "enable-boot":
      enableBoot()
    of "disable-boot":
      disableBoot()
    of "status-boot":
      checkBoot()
    of "changeid":
      changeID()
    of "myip":
      checkIP()
    of "help":
      devBanner()
      helpBanner()
    else:
      callback_send_msg(callback_msg_proc, "AnonSurf CLI", "Invalid option " & paramStr(1), 2)

checkOptions()
