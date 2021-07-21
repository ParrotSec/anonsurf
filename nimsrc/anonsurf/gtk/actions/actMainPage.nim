import gintro / [gtk, glib, vte, gobject]
import .. / modules / [myip, changeid, runsurf]
import .. / displays / [noti, askKill]
import strutils
import system
import os

type
  MyIP = object
    thisAddr*: string
    isUnderTor*: string
    iconName*: string

var
  worker*: system.Thread[void]
  channel*: Channel[MyIP]

channel.open()


proc doCheckIP() =
  #[
    Actual IP check for AnonSurf
    It parses data from server and show notification
  ]#

  var finalResult: MyIP
  let ipInfo = checkIPFromTorServer()
  # If program has error while getting IP address
  if ipInfo[0].startsWith("Error"):
    finalResult.iconName = "error"
  # If program runs but user didn't connect to tor
  elif ipInfo[0].startsWith("Sorry"):
    finalResult.iconName = "security-medium"
  # Connected to tor
  else:
    finalResult.iconName = "security-high"

  finalResult.isUnderTor = ipInfo[0]
  finalResult.thisAddr = ipInfo[1]
  channel.send(finalResult)


proc onClickCheckIP*(b: Button) =
  #[
    Display IP when user click on CheckIP button
    Show the information in system's notification
  ]#
  sendNotify("My IP", "Getting data from server", "dialog-information")
  createThread(worker, doCheckIP)


proc onClickRun*(b: Button) =
  #[
    Create condition to Start / Stop AnonSurf when click on btn1
  ]#
  if b.label == "Start":
    initAskDialog()
    createThread(worker, start)
  else:
    retCode.open()
    createThread(worker, stop)
    worker.joinThread()
    #[
      Check return code here before ask
      1. If user typed password (and it is correct):
        return code == 0 -> ask
      2. if user cancelled gksudo:
        return code == 255. Do not ask
      3. error or wrong password ?
        return code == 3 for wrong password (3 times)
    ]#
    let stopResult = retCode.tryRecv()
    if stopResult.dataAvailable and stopResult.msg == 0:
      initAskDialog()
    retcode.close()


proc onClickRestart*(b: Button) =
  #[
    Run anonsurf restart
  ]#
  # if spawnCommandLineAsync("gksudo /usr/bin/anonsurf restart"):
  #   let imgStatus = newImageFromIconName("system-restart-panel", 3)
  #   b.setImage(imgStatus)
  # else:
  #   discard
  # discard spawnCommandLineAsync("gksudo /usr/sbin/service anonsurfd restart")
  createThread(worker, restart)


proc onClickChangeID*(b: Button) =
  #[
    Use control port to change ID of Tor network
    1. Read password from nyxrc
    2. Get ControlPort from Torrc
    3. Send authentication request + NewNYM command
  ]#
  let conf = "/etc/anonsurf/nyxrc"
  if fileExists(conf):
    try:
      let recvData = doChangeID(conf)
      if recvData[0] != "250 OK\c":
        sendNotify("Identity Change Error", recvData[0], "error")
      else:
        if recvData[1] != "250 OK\c":
          sendNotify("Identity Change Error", recvData[1], "error")
        else:
          # Success. Show okay
          sendNotify("Identity Change Success", "You have a new identity", "security-high")
      # else:
      #   sendNotify("Identity Change Error", "Can parse settings", "error")
    except:
      sendNotify("Identity Change Error", "Error while connecting to control port", "security-low")
      echo getCurrentExceptionMsg()
  else:
    sendNotify("Identity Change Error", "File not found", "error")


proc upgradeCallback(terminal: ptr Terminal00; pid: int32; error: ptr glib.Error; userData: pointer) {.cdecl.} =
  #[
    Dummy callback proc to fix problem of VTE
  ]#
  discard


proc onVTEExit(v: Terminal, signal: int, d: Dialog) =
  d.destroy()


proc onClickTorStatus*(b: Button) =
  #[
    Spawn a native GTK terminal and run nyx with it to show current tor status
  ]#
  let
    statusDialog = newDialog()
    statusArea = statusDialog.getContentArea()
    nyxTerm = newTerminal()

  statusDialog.setTitle("Tor bandwidth")

  nyxTerm.connect("child-exited", onVTEExit, statusDialog)
  nyxTerm.spawnAsync(
    {noLastlog}, # pty flags
    nil, # working directory
    ["/usr/bin/nyx", "--config", "/etc/anonsurf/nyxrc"], # args
    [], # envv
    {}, # spawn flag
    nil, # Child setup
    nil, # child setup data
    nil, # chlid setup data destroy
    -1, # timeout
    nil, # cancellabel
    upgradeCallback, # callback
    nil, # pointer
  )

  statusArea.packStart(nyxTerm, false, true, 3)
  statusDialog.showAll()
