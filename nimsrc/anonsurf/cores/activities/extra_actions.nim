import strscans
import net
import strutils
import httpclient
import .. / commons / [parse_config, parse_resp]


proc ansurf_extra_checkIP*(): array[2, string] =
    #[
    Check current public IP using https://check.torproject.org/ 
  ]#
  const
    target = "https://check.torproject.org/"
  var
    client = newHttpClient()
  
  try:
    let
      resp = client.get(target)
      info = parseIPFromTorServer(resp.body)
    return info
  except Exception:
    stderr.write("[x] Get IP by Tor server error! Reason:\n" & getCurrentExceptionMsg() & "\n")
    return ["Error while getting IP information", getCurrentExceptionMsg()]


proc ansurf_extra_changeID*(conf: string): seq[string] =
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
