import strutils
import osproc
import os
import displays / noti
import modules / [myip, changeid]
import .. / utils / services
import cli / [cores, help]


proc askUser(): bool =
  if not isDesktop:
    return cliUserAsk()
  else:
    discard # TODO use select box of question here


proc killApps() =
  # TODO better msg
  const
    killCommand = "killall -q chrome dropbox skype icedove thunderbird firefox firefox-esr chromium xchat hexchat transmission steam firejail /usr/lib/firefox/firefox"
    cacheCommand = "bleachbit -c adobe_reader.cache chromium.cache chromium.current_session chromium.history elinks.history emesene.cache epiphany.cache firefox.url_history flash.cache flash.cookies google_chrome.cache google_chrome.history  links2.history opera.cache opera.search_history opera.url_history &> /dev/null"
  if askUser():
    let
      killResult = execCmd(killCommand)
      cacheResult = execCmd(cacheCommand)
    if killResult == 0 and cacheResult == 0:
      if isDesktop:
        sendNotify("AnonSurf", "Killed dangerous application", "security-high")
      else:
        echo "[*] Killed dangerous applications"
    else:
      if isDesktop:
        sendNotify("AnonSurf", "Error while trying to kill applications", "security-medium")
      else:
        echo "[!] Error while trying to kill dangerous applications"


proc checkIP() =
  sendNotify("My IP", "Getting data from server", "dialog-information")
  let info = checkIPFromTorServer()
  # Error
  if info[0].startsWith("Error"):
    if isDesktop:
      sendNotify("Error why checking IP", info[1], "error")
    else:
      echo "[x] Error while checking IP\n" & info[1]
  # If program runs but user didn't connect to tor
  elif info[0].startsWith("Sorry"):
    if isDesktop:
      sendNotify("You are not under Tor network", info[1], "security-low")
    else:
      echo "[!] You are not connecting to Tor network\n" & info[1]
  # Connected to tor
  else:
    if isDesktop:
      sendNotify("You are under Tor network", info[1], "security-high")
    else:
      echo "[!] You are under Tor network\n" & info[1]


proc start() =
  # start daemon
  # Check if all services are started
  const
    command = "/usr/sbin/service anonsurfd start"
  if getServStatus("anonsurfd") == 1:
    if isDesktop:
      sendNotify("AnonSurf", "AnonSurf is running. Can't start it again", "security-low")
    else:
      echo "[x] AnonSurf is running. Can't start it again."
    return

  killApps()
  runOSCommand(command, "Start AnonSurf Daemon")

  # Check AnonSurf Daemon status after start
  # TODO maybe better complex check
  if getServStatus("anonsurfd") == 1:
    if isDesktop:
      sendNotify("AnonSurf", "You are under Tor network", "security-high")
    else:
      echo "[x] You are under Tor network."
  else:
    if isDesktop:
      sendNotify("AnonSurf", "AnonSurf Daemon is not running", "security-low")
    else:
      echo "[x] AnonSurf Daemon is not running."


proc stop() =
  # stop daemon
  # show notifi
  const
    command = "/usr/sbin/service anonsurfd stop"
  if getServStatus("anonsurfd") != 1:
    if isDesktop:
      sendNotify("AnonSurf", "AnonSurf is not running. Can't stop it", "security-low")
    else:
      echo "[x] AnonSurf is not running. Can't stop it."
    return
  runOSCommand(command, "Stop AnonSurf Daemon")
  killApps()


proc restart() =
  const
    command = "/usr/sbin/service anonsurfd restart"
  if getServStatus("anonsurfd") != 1:
    if isDesktop:
      sendNotify("AnonSurf", "AnonSurf is not running. Can't restart it", "security-low")
    else:
      echo "[x] AnonSurf is not running. Can't restart it."
    return
  runOSCommand(command, "Restart AnonSurf Daemon")


proc checkBoot() =
  # no launcher. No send notify
  # check if it is started with boot and show popup
  let bootResult = isServEnabled("anonsurfd.service")
  if bootResult:
    if isDesktop:
      sendNotify("AnonSurf", "AnonSurf is enabled at boot", "security-high")
    else:
      echo "[*] AnonSurf is enabled at boot"
  else:
    if isDesktop:
      sendNOtify("AnonSurf", "AnonSurf is not enabled at boot", "security-medium")
    else:
      echo "[!] AnonSurf is not enabled at boot"


proc enableBoot() =
  # no launcher. No send notify
  const
    command = "/usr/bin/systemctl enable anonsurfd"
  # enable anosnurf at boot (systemd only for now)
  if isServEnabled("anonsurfd.service"):
    echo "[x] AnonSurf is already enabled!"
  else:
    runOSCommand(command, "Enable AnonSurf at boot")


proc disableBoot() =
  # disable anonsurf at boot (systemd only for now)
  # no launcher. No send notify
  const
    command = "/usr/bin/systemctl disable anonsurfd"
  if not isServEnabled("anonsurfd.service"):
    echo "[x] AnonSurf is already disabled!"
  else:
    runOSCommand(command, "Disable AnonSurf at boot")


proc changeID() =
  # change id just like gui
  if getServStatus("anonsurfd") != 1:
    if isDesktop:
      sendNotify("AnonSurf", "AnonSurf is not running. Can't change ID", "error")
    else:
      echo "[x] AnonSurf is not running. Can't change your ID"
    return
  
  let conf = "/etc/anonsurf/nyxrc"
  if fileExists(conf):
    try:
      let recvData = doChangeID(conf)
      if recvData[0] != "250 OK\c":
        if isDesktop:
          sendNotify("Identity Change Error", recvData[0], "error")
        else:
          echo "[x] Failed to change Identity"
      else:
        if recvData[1] != "250 OK\c":
          if isDesktop:
            sendNotify("Identity Change Error", recvData[1], "error")
          else:
            echo "[x] Failed to change Identity"
        else:
          # Success. Show okay
          if isDesktop:
            sendNotify("Identity Change Success", "You have a new identity", "security-high")
          else:
            echo "[*] Change Identity success"
    except:
      if isDesktop:
        sendNotify("Identity Change Error", "Error while connecting to control port", "security-low")
      else:
        echo "[x] Error while changing ID"
        echo getCurrentExceptionMsg()
  else:
    if isDesktop:
      sendNotify("Identity Change Error", "File not found", "error")
    else:
      echo "[x] Config file not found"


proc status() =
  # Show nyx
  if getServStatus("anonsurfd") != 1:
    if isDesktop:
      sendNotify("AnonSurf", "AnonSurf is not running", "security-low")
    else:
      echo "[x] AnonSurf is not running."
  else:
    if not fileExists("/etc/anonsurf/nyxrc"):
      if isDesktop:
        sendNotify("AnonSurf", "Can't find nyx configuration", "error")
      else:
        echo "[x] Can't find nyx configuration"
    else:
      discard execCmd("/usr/bin/nyx --config /etc/anonsurf/nyxrc")


proc dns() =
  echo "[!] Please use DNS tool instead"


proc checkOptions() =
  devBanner()
  if paramCount() != 1:
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
    of "dns":
      dns()
    of "help":
      helpBanner()
    else:
      if isDesktop:
        sendNotify("AnonSurf", "Invalid option " & paramStr(1), "error")
      else:
        echo "[x] Invalid option " & paramStr(1)

checkOptions()