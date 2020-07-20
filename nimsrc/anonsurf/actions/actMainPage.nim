import gintro / [gtk, glib]
import .. / modules / [myip, torPorts]
import .. / displays / noti
import strutils
import net
import strscans
import system

var worker*: system.Thread[void]


proc doCheckIP(ipInfo: array[2, string]) =
  #[
    Actual IP check for AnonSurf
    It parses data from server and show notification
  ]#
  var iconName: string
  
  # If program has error while getting IP address
  if ipInfo[0].startsWith("Error"):
    iconName = "error"
  # If program runs but user didn't connect to tor
  elif ipInfo[0].startsWith("Sorry"):
    iconName = "security-medium"
  # Connected to tor
  else:
    iconName = "security-high"

  sendNotify(ipInfo[0], ipInfo[1], iconName)


proc work() =
  #[
    Create backgroud thread to check IP
  ]#
  let ipAddr = checkIPFromTorServer()
  doCheckIP(ipAddr)


proc onClickCheckIP*(b: Button) =
  #[
    Display IP when user click on CheckIP button
    Show the information in system's notification
  ]#

  createThread(worker, work)
  worker.joinThread()


proc onClickRun*(b: Button) =
  #[
    Create condition to Start / Stop AnonSurf when click on btn1
  ]#
  if b.label == "Start":
    discard spawnCommandLineAsync("gksudo /usr/bin/anonsurf start")
  else:
    discard spawnCommandLineAsync("gksudo /usr/bin/anonsurf stop")


proc onClickChangeID*(b: Button) =
  #[
    Use control port to change ID of Tor network
    1. Read password from nyxrc
    2. Get ControlPort from Torrc
    3. Send authentication request + NewNYM command
  ]#
  var
    tmp, passwd: string
    sock = net.newSocket()
  
  if scanf(readFile("/etc/anonsurf/nyxrc"), "$w $w", tmp, passwd):
    let controlPort = getTorrcPorts().controlPort
    # sock.connect("127.0.0.1", Port(9051))
    if ":" in controlPort:
      sock.connect("127.0.0.1", Port(parseInt(controlPort.split(":")[1])))
    else:
      sock.connect("127.0.0.1", Port(parseInt(controlPort)))
    sock.send("authenticate \"" & passwd & "\"\nsignal newnym\nquit\n")
    let recvData = sock.recv(256).split("\n")
    sock.close()
    # Check authentication status
    if recvData[0] != "250 OK\c":
      sendNotify(
        "Identity Change Error",
        recvData[0],
        "error"
      )
      return
    # Check command status
    if recvData[1] != "250 OK\c":
      sendNotify(
        "Identity Change Error",
        recvData[1],
        "error"
      )
      return
    # Success. Show okay
    sendNotify(
      "Identity Change Success",
      "You have a new identity",
      "security-high"
    )
  else:
    sendNotify(
      "Identity Change Error",
      "Can parse settings",
      "error"
    )
