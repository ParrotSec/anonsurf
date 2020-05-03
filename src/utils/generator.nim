import random
import strutils
import std/sha1

randomize()

proc generatePassword*(): string =
  #[
    Generate random string
  ]#
  let randLen = rand(8..16)
  var password = ""
  for i in 0.. randLen:
    password = password & sample(strutils.Letters)

  return password


proc generateHashsum*(password: string): string =
  #[
    Generate sha1 sum and return as string
  ]#
  return $secureHash(password)


proc genBridgeAddr*(): string =
  #[
    Read the list from official list
    Random selecting from the list
  ]#
  const
    basePath = "/etc/anonsurf/obfs4bridge.list" # TODO change here. Development only
    # basePath = "/home/dmknght/Parrot_Projects/anonsurf/obfs4bridge.list"

  var
    allBridgeAddr: seq[string]

  for line in lines(basePath):
    if not line.startsWith("#") and not isEmptyOrWhitespace(line):
      allBridgeAddr.add(line)
  
  return sample(allBridgeAddr)


proc genTorrc*(isTorBridge: bool = false): string =
  const
    basePath = "/etc/anonsurf/torrc.base" # TODO change here. Development only
    # basePath = "/home/dmknght/Parrot_Projects/anonsurf/torrc.base"

  result = readFile(basePath)

  result &= "\nHashedControlPassword 16:" & generateHashsum(generatePassword()) & "\n\n"

  if isTorBridge == true:
    # https://sigvids.gitlab.io/create-tor-private-obfs4-bridges.html
    # https://community.torproject.org/relay/setup/bridge/debian-ubuntu/
    result &= "#Bridge config\nUseBridges 1\nBridgeRelay 1\nExtORPort auto\n"
    result &= "ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy managed\nORPort 9001\nServerTransportListenAddr obfs4 0.0.0.0:9443\n" # TODO check here Security reason
    result &= "Bridge " & genBridgeAddr() & "\n"
    # result &= "ServerTransportListenAddr obfs4 0.0.0.0:9443\n" # TODO check here. Security reason
    # TODO ServerTransportListenAddr obfs4 0.0.0.0:TODO2
