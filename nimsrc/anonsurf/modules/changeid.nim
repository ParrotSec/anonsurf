import strscans
import os
import net
import torPorts
import strutils
import .. / displays / noti


proc doChangeID*() =
  let conf = "/etc/anonsurf/nyxrc"
  if fileExists(conf):
    var
      tmp, passwd: string
      sock = net.newSocket()
    
    if scanf(readFile(conf), "$w $w", tmp, passwd):
      try:
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
      except:
        sendNotify(
          "Identity Change Error",
          "Error while connecting to control port",
          "security-low"
        )
        echo getCurrentExceptionMsg()
    else:
      sendNotify(
        "Identity Change Error",
        "Can parse settings",
        "error"
      )
  else:
    sendNotify(
        "Identity Change Error",
        "File not found",
        "error"
      )