import gintro / gtk
import .. / .. / modules / myip
import .. / display / noti
import strutils
import osproc
import net
import strscans


proc onClickCheckIP*(b: Button) =
  #[
    Display IP when user click on CheckIP button
    Show the information in system's notification
  ]#

  let ipInfo = checkIPwTorServer()
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


proc onClickRun*(b: Button) =
  if b.label == "Start":
    discard execCmd("gksudo /usr/bin/anonsurf start")
    b.label = "Stop"
  else:
    discard execCmd("gksudo /usr/bin/anonsurf stop")
    b.label = "Start"


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
        "Change Identify Error",
        recvData[0],
        "error"
      )
      return
    # Check command status
    if recvData[1] != "250 OK\c":
      sendNotify(
        "Change Identify Error",
        recvData[1],
        "error"
      )
      return
    # Success. Show okay
    sendNotify(
      "Change Identify Success",
      "You have a new identify",
      "security-high"
    )
  else:
    sendNotify(
      "Change Identify Error",
      "Can parse settings",
      "error"
    )
