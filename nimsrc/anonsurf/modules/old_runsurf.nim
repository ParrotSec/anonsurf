import osproc
# import .. / displays / askKill
var retCode*: Channel[int]


proc start*() =
  const
    command = "gksudo /usr/sbin/service anonsurfd start"
  # let runResult = execCmd(command)
  discard execCmd(command)
  # retCode.send(runResult)
  # if runResult == 0:
  #   discard # send notify done
  # else:
  #   discard # send notify failed


proc stop*() =
  const
    command = "gksudo /usr/sbin/service anonsurfd stop"
  let runResult = execCmd(command)
  retCode.send(runResult)
  # if runResult == 0:
  #   discard # send notify done
  # else:
  #   discard # send notify failed


proc restart*() =
  const
    command = "gksudo /usr/sbin/service anonsurfd restart"
  # let runResult = execCmd(command)
  discard execCmd(command)
  # retCode.send(runResult)
  # if runResult == 0:
  #   discard # send notify done
  # else:
  #   discard # send notify failed
