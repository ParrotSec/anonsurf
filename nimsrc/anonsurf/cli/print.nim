import strformat

const
  B_MAGENTA = "\e[95m"
  B_GREEN = "\e[92m"
  B_RED = "\e[91m"
  B_CYAN = "\e[96m"
  B_BLUE = "\e[94m"
  RESET = "\e[0m"


proc msgOk*(msg: string) =
  echo fmt"[{B_GREEN}*{RESET}] {B_GREEN}{msg}{RESET}"


proc msgWarn*(msg: string) =
  echo fmt"[{B_MAGENTA}!{RESET}] {B_BLUE}{msg}{RESET}"


proc msgErr*(msg: string) =
  echo fmt"[{B_RED}x{RESET}] {B_CYAN}{msg}{RESET}"
