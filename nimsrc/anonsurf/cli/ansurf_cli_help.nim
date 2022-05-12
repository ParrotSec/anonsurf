import .. / cores / version
import strformat

const
  B_MAGENTA = "\e[95m"
  B_GREEN = "\e[92m"
  B_RED = "\e[91m"
  B_CYAN = "\e[96m"
  B_BLUE = "\e[94m"
  RESET = "\e[0m"


proc helpCommand(command, description: string) =
  echo fmt"{B_RED}   {command:12}{B_BLUE} | {B_CYAN} {description}{RESET}"


proc helpBanner*() =
  echo "\nUsage: ", B_CYAN, "anonsurf ", B_BLUE, "<options>", RESET
  echo(B_BLUE, "  -------------------------------------------------------------------", RESET)
  helpCommand("option", "Description")
  echo(B_BLUE, "  --------------|----------------------------------------------------", RESET)
  helpCommand("help", "Show help table. Try `man anonsurf` for more info")
  helpCommand("start", "Start system-wide Tor transparent proxy")
  helpCommand("stop", "Stop Tor proxy and return to clearnet")
  helpCommand("restart", "Restart Tor proxy daemon")
  helpCommand("changeid", "Change your identity on Tor network randomly")
  helpCommand("status", "Show current status of connection under Tor proxy")
  helpCommand("myip", "Check public IP address")
  helpCommand("status-boot", "Check if AnonSurf is enabled at boot")
  helpCommand("enable-boot", "Enable AnonSurf at boot")
  helpCommand("disable-boot", "Disable AnonSurf at boot")
  echo(B_BLUE, "  -------------------------------------------------------------------", RESET)


proc devBanner*() =
  echo "AnonSurf [", B_RED, surfVersion, RESET, "] - ", B_CYAN, "Command Line Interface", RESET
  echo "\nDeveloped by:"
  echo B_GREEN, "  Lorenzo \"Palinuro\" Faletra", B_BLUE, " <palinuro@parrotsec.org>", RESET
  echo B_GREEN, "  Lisetta \"Sheireen\" Ferrero", B_BLUE, " <sheireen@parrotsec.org>", RESET
  echo B_GREEN, "  Francesco \"Mibofra\" Bonanno", B_BLUE, " <mibofra@parrotsec.org>", RESET
  echo "Extended by:"
  echo B_GREEN, "  Daniel \"Sawyer\" Garcia", B_BLUE, " <dagaba13@gmail.com>", RESET
  echo "Maintained by:"
  echo B_MAGENTA, "  Nong Hoang \"DmKnght\" Tu", B_BLUE, " <dmknght@parrotsec.org>", RESET
  echo "and a huge amount of Caffeine, Mountain Dew + some GNU/GPL v3 stuff"
