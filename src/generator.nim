import random
import strutils
import std/sha1

randomize()

proc generatePassword(): string =
  let randLen = rand(8..16)
  var password = ""
  for i in 0.. randLen:
    password = password & sample(strutils.Letters)

  return password


proc generateHashsum(password: string): string =
  let result = secureHash(password)
  return password
