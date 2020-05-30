import utils / generator
import os


const
  anonTorrc = "/etc/anonsurf/torrc"
  torTorrc = "/etc/tor/torrc"
  torTorrcBak = "/etc/tor/torrc.bak"


proc restoreTorrc() =
  #[
    Restore backup of torrc
  ]#
  if fileExists(torTorrcBak):
    if tryRemoveFile(torTorrc):
      moveFile(torTorrcBak, torTorrc)
      stdout.write("[+] Restored backup for torrc")
    else:
      stderr.write("[x] Can not remove AnonSurf's torrc\n")
  else:
    stderr.write("[x] Can find backup file. Ignore\n")


proc replaceTorrc() =
  #[
    We replace torrc's setting by our anonsurf settings then call tor
    1. Make a backup for current torrc (which should be from tor side)
    2. Create symlink for torrc file from /etc/anonsurf/torrc
    The torrc should be make before we call it
  ]#

  # Check if Torrc is a symlink or PC file. Just in case something is wrong
  if fileExists(torTorrc):
    stdout.write("[+] Start replacing torrc\n")
    let torrcInfo = getFileInfo(torTorrc, followSymlink = false)
    
    # If Torrc file is not a symlink then we do create backup
    if torrcInfo.kind == pcFile:
      stdout.write("[+] Creating tor's torrc backup\n")
      moveFile(torTorrc, torTorrcBak)
      stdout.write("[+] Using AnonSurf's torrc confing\n")
      createSymlink(anonTorrc, torTorrc)
    # else we remove file and create symlink
    else:
      stdout.write("[+] Torrc is a symlink. We don't create a backup\n")
      if tryRemoveFile(torTorrc):
        createSymlink(anonTorrc, torTorrc)
      else:
        stderr.write("[x] Can not remove " & torTorrc & "\n")
  else:
    stderr.write("[x] Can not find " & torTorrc & "\n")
    stdout.write("[+] Force using AnonSurf's torrc confing\n")
    createSymlink(anonTorrc, torTorrc)


proc makeTorrc*(isTorBridge: bool = false) =
  var
    torData = ""
  
  if not tryRemoveFile(anonTorrc):
    stderr.write("[x] Error while removing torrc\n")
    return

  torData = genTorrc(isTorBridge)
  # if not isTorBridge:
  #   torData = genTorrc()
  # else:
  #   # TODO add generate bridge
  #   discard
  try:
    writeFile(anonTorrc, torData)
  except:
    stderr.write("[x] Error while making new Torrc file\n")


proc main() =
  if paramCount() == 0:
    makeTorrc()
    replaceTorrc()
  elif paramCount() == 1:
    if paramStr(1) == "bridge":
      makeTorrc(true)
      replaceTorrc()
    elif paramStr(1) == "restore":
      restoreTorrc()
    else:
      echo "[-] Unknown option"
  else:
    echo "[-] Unknown args"

main()
