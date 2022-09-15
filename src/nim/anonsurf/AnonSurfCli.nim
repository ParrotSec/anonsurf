import osproc
import os
import cores / commons / [services_status, ansurf_objects]
import cores / [handle_killapps, handle_activities]
import cli / ansurf_cli_help

#[
  isDesktop: bool -> Check if current OS has Desktop Environment.
    if true:
      Use DE's notifications, ask kill apps using GTK
    if false:
      Use CLI for output msg, ask kill apps, ...
  callback_msg_proc: callback proc to call by other functions
  callback_kill_apps: callback kill applications to call by other functions
  sudo: return "gksudo" or "sudo" depends on Desktop Environment

]#
let
  isDesktop = if getEnv("XDG_CURRENT_DESKTOP") == "": false else: true
  callback_msg_proc = cli_init_callback_msg(isDesktop)
  callback_kill_apps = init_cli_askkill(isDesktop)
  sudo = cmd_init_sudo(isDesktop)


proc check_ip() =
  #[
    Try to get public IP of current client
    This function calls handle_checkIP, which connects to Tor's server
    and then parses result
  ]#
  ansurf_acts_handle_checkIP(callback_msg_proc)


proc start() =
  # Start Anonsurf's Daemon
  if getServStatus("anonsurfd"):
    callback_msg_proc("AnonSurf Status", "AnonSurf is running. Can't start it again", SecurityLow)
    return

  callback_kill_apps(callback_msg_proc)
  ansurf_acts_handle_start(sudo, callback_msg_proc)


proc stop() =
  # Stop Anonsurf's Daemon. If anonsurf didn't run, return
  if not getServStatus("anonsurfd"):
    callback_msg_proc("AnonSurf Status", "AnonSurf is not running. Can't stop it", SecurityLow)
    return
  ansurf_acts_handle_stop(sudo, callback_msg_proc)
  # Only do kill apps when anonsurf is not running.
  if not getServStatus("anonsurfd"):
    callback_kill_apps(callback_msg_proc)


proc restart() =
  # Restart Anonsurf's Daemon
  ansurf_acts_handle_restart(sudo, callback_msg_proc)


proc checkBoot() =
  # Check if AnonSurf is enabled at boot
  let bootResult = isServEnabled("anonsurfd.service")
  if bootResult:
    callback_msg_proc("Startup check", "AnonSurf is enabled at boot", SecurityHigh)
  else:
    callback_msg_proc("Startup check", "AnonSurf is not enabled at boot", SecurityMedium)


proc enableBoot() =
  # Enable AnonSurf as system service at boot
  ansurf_acts_handle_boot_enable(sudo, callback_msg_proc)
  checkBoot()


proc disableBoot() =
  # Disable AnonSurf as system service at boot
  ansurf_acts_handle_boot_disable(sudo, callback_msg_proc)
  checkBoot()


proc changeID() =
  # Change Tor's ID by sending signal to control port
  ansurf_acts_handle_changeID(callback_msg_proc)


proc status() =
  # Show nyx
  if not getServStatus("anonsurfd"):
    callback_msg_proc("AnonSurf Status", "AnonSurf is not running", SecurityLow)
  else:
    if not fileExists("/etc/anonsurf/nyxrc"):
      callback_msg_proc("AnonSurf Status", "Nyxrc is not found", SecurityHigh)
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
        callback_msg_proc("System check", "No system init is running", SecurityLow)
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
      callback_msg_proc("AnonSurf CLI", "Invalid option " & paramStr(1), SecurityLow)

checkOptions()
