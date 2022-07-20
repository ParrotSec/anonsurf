import strformat
import gintro / notify
import .. / commons / ansurf_objects


proc cli_send_msg*(title, body: string, code: StatusImg) =
  #[
    Print message to CLI
    0: Ok
    1. Warn
    2. Error
  ]#
  const
    B_MAGENTA = "\e[95m"
    B_GREEN = "\e[92m"
    B_RED = "\e[91m"
    B_CYAN = "\e[96m"
    B_BLUE = "\e[94m"
    RESET = "\e[0m"

  case code
  of SecurityHigh:
    echo fmt"[{B_GREEN}*{RESET}] {title}"
    echo fmt"{B_GREEN}{body}{RESET}"
  of SecurityMedium:
    echo fmt"[{B_MAGENTA}!{RESET}] {title}"
    echo fmt"{B_BLUE}{body}{RESET}"
  of SecurityLow:
    echo fmt"[{B_RED}x{RESET}] {title}"
    echo fmt"{B_CYAN}{body}{RESET}"
  of SecurityInfo:
    echo fmt"[{B_BLUE}+{RESET}] {title}"
    echo fmt"{B_BLUE}{body}{RESET}"


proc gtk_send_msg*(title, body: string, code: StatusImg) =
  #[
    Display notification with custom title, body
    0: Ok
    1. Warn
    2. Error
    3. Info
  ]#
  var
    notifi: Notification

  discard init("AnonSurf GUI notification")
  case code
  of SecurityHigh:
    notifi = newNotification(title, body, cstring("security-high"))
  of SecurityMedium:
    notifi = newNotification(title, body, cstring("security-medium"))
  of SecurityLow:
    notifi = newNotification(title, body, cstring("security-low"))
  of SecurityInfo:
    notifi = newNotification(title, body, cstring("dialog-information"))
  discard notifi.show()
