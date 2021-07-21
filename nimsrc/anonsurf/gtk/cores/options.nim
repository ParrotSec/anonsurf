#[
  https://nim-lang.org/docs/json.html
  str -> json: parseJson()
  json -> str: $
  obj -> json: %
  json -> obj: to()
]#

import json
import os

type
  AnonOptions* = object
    use_bridge*: bool
    custom_bridge*: bool
    bridge_addr*: string

let
  bridgePath* = "/etc/anonsurf/bridges.txt"
  defConfPath* = "/etc/anonsurf/anonrc"
  defConfVal = AnonOptions(
    use_bridge: false,
    custom_bridge: false,
    bridge_addr: "",
  )


proc readConf*(p: string): AnonOptions =
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
