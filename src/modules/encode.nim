import parser
# import parseutils
import strutils


proc parseAddrToHex(ip: string): string =
  for octet in ip.split("."):
    result = parseInt(octet).toHex(2) & result


proc parsePortToHex(port: string): string =
  discard


proc toNixHex*(self: TorConfig) =
  # Convert address to be nyx in /proc/net/tcp
  discard

echo parsePortToHex("8080")