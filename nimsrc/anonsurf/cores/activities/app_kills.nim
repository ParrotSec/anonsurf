import posix
import os
import strutils


proc ansurf_kill_sendkill*(): int =
  const
    processes = @["chrome", "dropbox", "skype", "icedove", "thunderbird", "firefox", "firefox-esr",
     "chromium", "xchat", "hexchat", "transmission", "steam", "firejail", "/usr/lib/firefox/firefox"]
    proc_path = "/proc/"
    signal = 9
  
  for kind, path in walkDir(proc_path):
    let process_cmd = path & "/cmdline"
    if kind == pcDir and fileExists(process_cmd):
      let command = readFile(process_cmd)
      if command in processes or command.splitPath.tail in processes:
        let pid = cast[Pid](parseInt(path.splitPath().tail))
        result += cast[int](kill(pid, signal))
