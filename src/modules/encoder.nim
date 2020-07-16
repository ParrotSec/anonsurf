import parser
import strutils


proc parseAddrToHex(ip: string): string =
  for octet in ip.split("."):
    result = parseInt(octet).toHex(2) & result


proc parsePortToHex(port: string): string =
  return parseInt(port).toHex(4)


proc handleParse(txt: string): string =
  if ":" in txt:
    return parseAddrToHex(txt.split(":")[0]) & ":" & parsePortTOHex(txt.split(":")[1])
  else:
    if "." in txt:
      return parseAddrToHex(txt.split(":")[0])
    else:
      return parsePortTOHex(txt.split(":")[1])


proc toNixHex*(conf: TorConfig): TorConfig =
  if conf.fileErr:
    discard
  else:
    result.controlPort = handleParse(conf.controlPort)
    result.dnsPort = handleParse(conf.dnsPort)
    result.socksPort = handleParse(conf.socksPort)
    result.transPort = handleParse(conf.transPort)
