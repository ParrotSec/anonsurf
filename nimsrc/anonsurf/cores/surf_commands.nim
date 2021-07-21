import osproc
import strformat


proc ans_start*(sudo: string): int =
  const
    command = "/usr/sbin/service anonsurfd start"
  return execCmd(fmt"{sudo} {command}")


proc ans_stop*(sudo: string): int =
  const
    command = "/usr/sbin/service anonsurfd stop"
  return execCmd(fmt"{sudo} {command}")


proc ans_restart*(sudo: string): int =
  const
    command = "/usr/sbin/service anonsurfd restart"
  return execCmd(fmt"{sudo} {command}")


proc ans_enable*(sudo: string): int =
  const
    command = "/usr/bin/systemctl enable anonsurfd"
  return execCmd(fmt"{sudo} {command}")


proc ans_disable*(sudo: string): int =
  const
    command = "/usr/bin/systemctl disable anonsurfd"
  return execCmd(fmt"{sudo} {command}")


proc cli_init_sudo*(isDesktop: bool): string =
  if isDesktop:
    return "gksudo"
  else:
    return "sudo"


proc cli_handle_start*(sudo: string, callback_proc: proc) =
  if ans_start(sudo) == 0:
    callback_proc("AnonSurf Start", "AnonSurf started", 0)
  else:
    callback_proc("AnonSurf Start", "AnonSurf failed to start", 2)


proc cli_handle_stop*(sudo: string, callback_proc: proc) =
  if ans_stop(sudo) == 0:
    callback_proc("AnonSurf Stop", "AnonSurf stopped", 0)
  else:
    callback_proc("AnonSurf Stop", "AnonSurf failed to stop", 2)


proc cli_handle_restart*(sudo: string, callback_proc: proc) =
  if ans_stop(sudo) == 0:
    callback_proc("AnonSurf Restart", "AnonSurf restarted", 0)
  else:
    callback_proc("AnonSurf Restart", "AnonSurf failed to restart", 2)


proc cli_handle_disable*(sudo: string, callback_proc: proc) =
  if ans_disable(sudo) == 0:
    callback_proc("AnonSurf Disable Boot", "Disabled AnonSurf at boot", 0)
  else:
    callback_proc("AnonSurf Disable Boot", "Failed to disable AnonSurf at boot", 2)


proc cli_handle_enable*(sudo: string, callback_proc: proc) =
  if ans_enable(sudo) == 0:
    callback_proc("AnonSurf Enable Boot", "Enabled AnonSurf at boot", 0)
  else:
    callback_proc("AnonSurf Enable Boot", "Failed to enable AnonSurf at boot", 2)
