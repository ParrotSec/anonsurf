# import strutils
import osproc
import os
import cores / commons / services
import cores / [handle_killapps, handle_activities]
import cli / help

let
  isDesktop = if getEnv("XDG_CURRENT_DESKTOP") == "": false else: true
  callback_msg_proc = cli_init_callback_msg(isDesktop)
  sudo = cmd_init_sudo(isDesktop)


proc check_ip() =
  # TODO check surf is running here
  ansurf_acts_handle_checkIP(callback_msg_proc)


proc start() =
  # start daemon
  # Check surf is not running here
  # Check if all services are started
  # killApps() # TODO kill app
  ansurf_acts_handle_start(sudo, callback_msg_proc)


proc stop() =
  # stop daemon
  # show notifi
  
  if not checkInitSystem():
    # callback_send_msg(callback_msg_proc, "System check", "No system init is running", 2)
    callback_msg_proc("System check", "No system init is running", 2)
    return

  if getServStatus("anonsurfd") != 0:
    # callback_send_msg(callback_msg_proc, "AnonSurf Status", "AnonSurf is not running", 1)
    callback_msg_proc("System check", "No system init is running", 2)
    return

  ansurf_acts_handle_stop(sudo, callback_msg_proc)
  # TODO kill app


proc restart() =
  if getServStatus("anonsurfd") != 0:
    callback_msg_proc("AnonSurf Status", "AnonSurf is not running", 1)
    return

  ansurf_acts_handle_restart(sudo, callback_msg_proc)


proc checkBoot() =
  # no launcher. No send notify
  # check if it is started with boot and show popup
  let bootResult = isServEnabled("anonsurfd.service")
  if bootResult:
    callback_msg_proc("Startup check", "AnonSurf is enabled at boot", 0)
  else:
    callback_msg_proc("Startup check", "AnonSurf is not enabled at boot", 0)


proc enableBoot() =
  # enable anosnurf at boot (systemd only for now)
  if isServEnabled("anonsurfd.service"):
    callback_msg_proc("Startup check", "AnonSurf is already enabled!", 1)
  else:
    ansurf_acts_handle_boot_enable(sudo, callback_msg_proc)
    checkBoot()


proc disableBoot() =
  if not isServEnabled("anonsurfd.service"):
    callback_msg_proc("Startup check", "AnonSurf is already disabled!", 1)
  else:
    ansurf_acts_handle_boot_disable(sudo, callback_msg_proc)
    checkBoot()


proc changeID() =
  # change id just like gui
  if getServStatus("anonsurfd") != 0:
    callback_msg_proc("AnonSurf Status", "AnonSurf is not running", 2)
    return
  
  ansurf_acts_handle_changeID(callback_msg_proc)


proc status() =
  # Show nyx
  if getServStatus("anonsurfd") != 0:
    callback_msg_proc("AnonSurf Status", "AnonSurf is not running", 2)
  else:
    if not fileExists("/etc/anonsurf/nyxrc"):
      callback_msg_proc("AnonSurf Status", "Nyxrc is not found", 0)
    else:
      discard execCmd("/usr/bin/nyx --config /etc/anonsurf/nyxrc")


proc checkOptions() =
  if paramCount() != 1:
    devBanner()
    helpBanner()
  else:
    if not checkInitSystem():
      if paramStr(1) == "help":
        devBanner()
        helpBanner()
        return
      else:
        callback_msg_proc("System check", "No system init is running", 2)
        return
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
      callback_msg_proc("AnonSurf CLI", "Invalid option " & paramStr(1), 2)

checkOptions()
