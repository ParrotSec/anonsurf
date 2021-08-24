import strscans
import net
import torPorts
import strutils


proc doChangeID*(conf: string): seq[string] =
  var
    tmp, passwd: string
    sock = net.newSocket()
  
  if scanf(readFile(conf), "$w $w", tmp, passwd):
    let controlPort = getTorrcPorts().controlPort
    # sock.connect("127.0.0.1", Port(9051))
    if ":" in controlPort:
      sock.connect("127.0.0.1", Port(parseInt(controlPort.split(":")[1])))
    else:
      sock.connect("127.0.0.1", Port(parseInt(controlPort)))
    sock.send("authenticate \"" & passwd & "\"\nsignal newnym\nquit\n")
    let recvData = sock.recv(256).split("\n")
    sock.close()
    return recvData
