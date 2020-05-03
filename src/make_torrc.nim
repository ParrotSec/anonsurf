import utils / generator
import os


proc makeTorrc*(isTorBridge: bool = false) =
  const
    anonPath = "/etc/anonsurf/torrc"

  var
    torData = ""
  
  if not tryRemoveFile(anonPath):
    stderr.write("[x] Error while removing torrc\n")
    return

  torData = genTorrc(isTorBridge)
  # if not isTorBridge:
  #   torData = genTorrc()
  # else:
  #   # TODO add generate bridge
  #   discard
  try:
    writeFile(anonPath, torData)
  except:
    stderr.write("[x] Error while making new Torrc file\n")


proc main() =
  if paramCount() == 0:
    makeTorrc()
  elif paramCount() == 1:
    if paramStr(1) == "bridge":
      makeTorrc(true)
    else:
      echo "[-] Unknown option"
  else:
    echo "[-] Unknown args"

main()
