import os
import strformat
import gintro / notify

type
  callback_send_messenger* = proc(title, body: string, code: int)

let isDesktop = if getEnv("XDG_CURRENT_DESKTOP") == "": false else: true


proc cli_send_msg(title, body: string, code: int) =
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
    
  if code == 0:
    echo fmt"[{B_GREEN}*{RESET}] {title}"
    echo fmt"{B_GREEN}{body}{RESET}"
  elif code == 1:
    echo fmt"[{B_MAGENTA}!{RESET}] {title}"
    echo fmt"{B_BLUE}{body}{RESET}"
  elif code == 2:
    echo fmt"[{B_RED}x{RESET}] {title}"
    echo fmt"{B_CYAN}{body}{RESET}"


proc gtk_send_msg(title, body: string, code: int) =
  #[
    Display notification with custom title, body
    0: Ok
    1. Warn
    2. Error
  ]#
  var icon_name = ""
  if code == 0:
    icon_name = "security-high"
  elif code == 1:
    icon_name = "security-medium"
  elif code == 2:
    icon_name = "security-low"

  discard init("AnonSurf GUI notification")
  let ipNotify = newNotification(title, body, icon_name)
  discard ipNotify.show()


proc cli_init_callback_msg*(): proc =
  if isDesktop:
    return gtk_send_msg
  else:
    return cli_send_msg


proc gtk_init_callback_msg*(): proc =
  return gtk_send_msg


proc callback_send_msg*(send_msg_proc: callback_send_messenger, title, body: string, code: int) =
  send_msg_proc(title, body, code)
