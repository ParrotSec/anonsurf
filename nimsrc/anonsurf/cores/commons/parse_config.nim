import os
import strutils

type
  TorConfig* = object
    fileErr*: bool # Error while reading file
    controlPort*: string
    transPort*: string
    socksPort*: string
    dnsPort*: string


proc getTorrcPorts*(): TorConfig =
  const
    path = "/etc/tor/torrc"

  if fileExists(path):
    result.fileErr = false
    for line in lines(path):
      if line.startsWith("TransPort"):
        result.transPort = line.split(" ")[1]
      elif line.startsWith("SocksPort"):
        result.socksPort = line.split(" ")[1]
      elif line.startsWith("DNSPort"):
        result.dnsPort = line.split(" ")[1]
      elif line.startsWith("ControlPort"):
        result.controlPort = line.split(" ")[1]
      else:
        discard
  else:
    result.fileErr = true


proc parseAddrToHex(ip: string): string =
  for octet in ip.split("."):
    result = parseInt(octet).toHex(2) & result


proc parsePortToHex(port: string): string =
  return parseInt(port).toHex(4)


proc handleParse(txt: string): string =
  if ":" in txt:
    # 127.0.0.1:8080
    return parseAddrToHex(txt.split(":")[0]) & ":" & parsePortTOHex(txt.split(":")[1])
  else:
    if "." in txt:
      # 127.0.0.1
      # Only address here, no port. Could be a bug
      return parseAddrToHex(txt)
    else:
      # 8080
      return parseAddrToHex("127.0.0.1") & ":" & parsePortToHex(txt)


proc toNixHex*(conf: TorConfig): TorConfig =
  if conf.fileErr:
    discard
  else:
    try:
      result.controlPort = handleParse(conf.controlPort)
      result.dnsPort = handleParse(conf.dnsPort)
      result.socksPort = handleParse(conf.socksPort)
      result.transPort = handleParse(conf.transPort)
    except:
      result.fileErr = true
