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


proc genTorrc*(): string =
  let
    baseData = readFile("/etc/anonsurf/torrc.base")

  return baseData & "\nHashedControlPassword 16:" & generateHashsum(generatePassword())
