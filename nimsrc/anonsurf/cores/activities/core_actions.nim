import osproc
import strformat


proc ansurf_core_start*(sudo: string): int =
  #[
    Start AnonSurf daemon as a service
    Args:
      sudo: string: either "gksudo" or "sudo" for cli / gui
    Return: int: error code of systemctl commmand
  ]#
  const
    command = "service anonsurfd start"
  return execCmd(fmt"{sudo} {command}")


proc ansurf_core_stop*(sudo: string): int =
  #[
    Stop AnonSurf daemon service
    Args:
      sudo: string: either "gksudo" or "sudo" for cli / gui
    Return: int: error code of systemctl commmand
  ]#
  const
    command = "service anonsurfd stop"
  return execCmd(fmt"{sudo} {command}")


proc ansurf_core_restart*(sudo: string): int =
  #[
    Restart AnonSurf daemon service
    Args:
      sudo: string: either "gksudo" or "sudo" for cli / gui
    Return: int: error code of systemctl commmand
  ]#
  const
    command = "service anonsurfd restart"
  return execCmd(fmt"{sudo} {command}")


proc ansurf_core_status*(): int =
  return execCmd("/usr/bin/nyx --config /etc/anonsurf/nyxrc")
