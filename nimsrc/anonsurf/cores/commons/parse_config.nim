import os
import strutils
import ansurf_objects
import json


proc getTorrcPorts*(): TorConfig =
  const
    path = "/etc/tor/torrc"

  if fileExists(path):
    result.fileErr = false
    for line in lines(path):
      if line.startsWith("TransPort"):
        result.transPort = line.split(" ")[1] # FIXME got crash randomly here
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


proc readConf*(p: string): AnonOptions =
  let defConfVal = AnonOptions(
    use_bridge: false,
    custom_bridge: false,
    bridge_addr: "",
  )
  if fileExists(p):
    var jnode = parseFile(p)
    return to(jnode, AnonOptions)
  else:
    stderr.write("[x] Config doesn't exists. Use default options\n")
    return defConfVal


proc readDefaultConfig*(): AnonOptions =
  return readConf(defConfPath)


proc writeConf*(p: string, op: AnonOptions) =
  try:
    writeFile(p, pretty(%op))
  except:
    stderr.write("[x] Error while writing config at " & p & "\n")
