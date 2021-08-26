import osproc
import strformat
import .. / commons / services_status


proc ansurf_boot_enable*(sudo: string): int =
  #[
    Use Init system to start AnonSurf at boot
    Args:
      sudo: string: either "gksudo" or "sudo" for cli / gui
    Return: int: error code of systemctl commmand
  ]#
  const
    command = "/usr/bin/systemctl enable anonsurfd"
  return execCmd(fmt"{sudo} {command}")


proc ansurf_boot_disable*(sudo: string): int =
  #[
    Use Init system to disable AnonSurf at boot.
    Args:
      sudo: string: either "gksudo" or "sudo" for cli / gui
    Return: int: error code of systemctl commmand
  ]#
  const
    command = "/usr/bin/systemctl disable anonsurfd"
  return execCmd(fmt"{sudo} {command}")


proc ansurf_boot_status*(): bool =
  #[
    Check if a service is enabled at boot
  ]#
  return isServEnabled("anonsurfd.service")
