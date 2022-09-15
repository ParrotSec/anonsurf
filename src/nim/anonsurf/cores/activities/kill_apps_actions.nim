import osproc
import .. / commons / ansurf_objects


proc ansurf_kill_apps*(callback_send_messages: callback_send_messenger) =
  const
    killScript = "/usr/lib/anonsurf/safekill"
  discard execCmd("bash " & killScript)
