import gintro / [gtk, glib]
import .. / modules / myip
import .. / displays / noti
import strutils
import net
import strscans
import system

var worker*: system.Thread[void]


proc doCheckIP(ipInfo: array[2, string]) =
  # let ipInfo = checkIPFromTorServer()
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
  let ipAddr = checkIPFromTorServer()
  # idleAdd(doCheckIP, ipAddr)
  doCheckIP(ipAddr)
  worker.joinThread()


proc onClickCheckIP*(b: Button) =
  #[
    Display IP when user click on CheckIP button
    Show the information in system's notification
  ]#

  createThread(worker, work)


proc onClickRun*(b: Button) =
  if b.label == "Start":
    discard spawnCommandLineAsync("gksudo /usr/bin/anonsurf start")
    # if spawnCommandLineAsync("gksudo /usr/bin/anonsurf start"):
    # # discard execCmd("gksudo /usr/bin/anonsurf start")
    #   b.label = "Starting"
    # else:
    #   discard
  else:
    discard spawnCommandLineAsync("gksudo /usr/bin/anonsurf stop")
    # discard execCmd("gksudo /usr/bin/anonsurf stop")
    # if spawnCommandLineAsync("gksudo /usr/bin/anonsurf stop"):
    #   b.label = "Stopping"
    # else:
    #   discard


proc onClickChangeID*(b: Button) =
  var
    tmp, passwd: string
    sock = net.newSocket()
  
  if scanf(readFile("/etc/anonsurf/nyxrc"), "$w $w", tmp, passwd):
    sock.connect("127.0.0.1", Port(9051))
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
