import strutils
import osproc
import os
import displays / noti
import modules / [myip, changeid]
import .. / utils / services

let isDesktop = if getEnv("XDG_CURRENT_DESKTOP") == "": false else: true

# TODO support headless and cli mode by checking XDG_CURRENT_DESKTOP or user args
# TODO select notification and cli only by headless
# scope: click on launcher: normal
# cli: headless or normal


proc runOSCommand(command, commandName: string) =
  var cmdResult: int
  if isDesktop:
    cmdResult = execCmd("gksudo " & command)
    if cmdResult == 0:
      sendNotify("AnonSurf", commandName & " success", "security-high")
    else:
      sendNotify("AnonSurf", commandName & " failed", "error")
  else:
    cmdResult = execCmd("sudo " & command)
    if cmdResult == 0:
      echo "[*] " & commandName & " success"
    else:
      echo "[x] " & commandName & " failed"


proc killApps() =
  const
    killCommand = "killall -q chrome dropbox skype icedove thunderbird firefox firefox-esr chromium xchat hexchat transmission steam firejail /usr/lib/firefox/firefox"
    cacheCommand = "bleachbit -c adobe_reader.cache chromium.cache chromium.current_session chromium.history elinks.history emesene.cache epiphany.cache firefox.url_history flash.cache flash.cookies google_chrome.cache google_chrome.history  links2.history opera.cache opera.search_history opera.url_history &> /dev/null"
  discard execCmd(killCommand)
  discard execCmd(cacheCommand)
  # TODO yes no question from cli or ask box
  # TODO notification


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
  # TODO show start anonsurf
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
  runOSCommand(command, "Start AnonSurf Daemon")


proc stop() =
  # show notifi
  # stop daemon
  # show notifi
  const
    command = "/usr/sbin/service anonsurfd stop"
  if getServStatus("anonsurfd") != 1:
    if isDesktop:
      sendNotify("AnonSurf", "AnonSurf is not running. Can't stop it.", "security-low")
    else:
      echo "[x] AnonSurf is not running. Can't stop it."
    return
  runOSCommand(command, "Stop AnonSurf Daemon")


proc checkBoot() =
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
  const
    command = "/usr/bin/systemctl enable anonsurfd"
  # enable anosnurf at boot (systemd only for now)
  # TODO check if it is enabled before turn on
  runOSCommand(command, "Enable AnonSurf at boot")


proc disableBoot() =
  # disable anonsurf at boot (systemd only for now)
  const
    command = "/usr/bin/systemctl disable anonsurfd"
  # TODO chekc if it is disabled before turn off
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
  # TODO check if path exists
  # run /usr/bin/nyx --config /etc/anonsurf/nyxrc or /usr/bin/nyx
  discard

# todo proc dns

# TODO check user's options
