import osproc
# import .. / displays / askKill


proc start*() =
  const
    command = "gksudo /usr/sbin/service anonsurfd start"
  let runResult = execCmd(command)
  if runResult == 0:
    discard # send notify done
  else:
    discard # send notify failed


proc stop*() =
  const
    command = "gksudo /usr/sbin/service anonsurfd stop"
  let runResult = execCmd(command)
  if runResult == 0:
    discard # send notify done
  else:
    discard # send notify failed


proc restart*() =
  const
    command = "gksudo /usr/sbin/service anonsurfd restart"
  let runResult = execCmd(command)
  if runResult == 0:
    discard # send notify done
  else:
    discard # send notify failed
