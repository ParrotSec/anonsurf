import osproc


proc an_kill_apps*(): int =
  const
    killCommand = "killall -q chrome dropbox skype icedove thunderbird firefox firefox-esr chromium xchat hexchat transmission steam firejail /usr/lib/firefox/firefox"
    cacheCommand = "bleachbit -c adobe_reader.cache chromium.cache chromium.session chromium.history chromium.form_history elinks.history emesene.cache epiphany.cache firefox.cache firefox.crash_reports firefox.url_history firefox.forms flash.cache flash.cookies google_chrome.cache google_chrome.history google_chrome.form_history google_chrome.search_engines google_chrome.session google_earth.temporary_files links2.history opera.cache opera.form_history opera.history &> /dev/null"
  let
    killResult = execCmd(killCommand)
    cacheResult = execCmd(cacheCommand)
  return killResult + cacheResult


import posix
import os
import strutils
# import strtabs # Dict-like object in Nim
# import sequtils


const apt_status_path = "/var/lib/dpkg/status"


proc query_installed(): seq[string] =
  var
    pkg_name: string
  for line in lines(apt_status_path):
    if line.startsWith("Package: "):
      pkg_name = line.split(": ")[1]
    elif line.startsWith("Status: "):
      if line == "Status: install ok installed":
        result.add(pkg_name)


proc ansurf_kill_sendkill*(): int =
  # const
  #   processes = @["chrome", "dropbox", "skype", "icedove", "thunderbird", "firefox", "firefox-esr",
  #    "chromium", "xchat", "hexchat", "transmission", "steam", "firejail", "/usr/lib/firefox/firefox"]
  #   proc_path = "/proc/"
  #   signal = 9

  #[
    killProcesses: List of packages in dict-like object which contain
      1. pkg_name: package name (which should be apt package name)
      2. prc_name: process name. Use to kill process
      3. prf_name: profile name: profiles of bleachbit
  ]#
  
  var killProcesses = @[
    {
      "pkg_name": "chromium",
      "prc_name": "chromium",
      "prf_name": "chromium.cache chromium.session chromium.history chromium.form_history",
    },
    {
      "pkg_name": "elinks",
      "prc_name": "elinks",
      "prf_name": "elinks.history",
    },
    {
      "pkg_name": "google-chrome-stable",
      "prc_name": "chrome",
      "prf_name": "google_chrome.cache google_chrome.history google_chrome.form_history google_chrome.search_engines google_chrome.session",
    },
    # TODO handle steam: steam:i386 on repo or package name on steam server
    {
      "pkg_name": "firefox",
      "prc_name": "firefox",
      "prf_name": "firefox.cache firefox.crash_reports firefox.url_history firefox.forms",
    },
    {
      "pkg_name": "firefox-esr",
      "prc_name": "firefox-esr",
      "prf_name": "firefox.cache firefox.crash_reports firefox.url_history firefox.forms", # bleachbit doesn't support firefox esr. TODO test
    },
    {
      "pkg_name": "opera-stable",
      "prc_name": "opera",
      "prf_name": "opera.cache opera.form_history opera.history",
    }
  ]
  
  # for kind, path in walkDir(proc_path):
  #   let process_cmd = path & "/cmdline"
  #   if kind == pcDir and fileExists(process_cmd):
  #     let command = readFile(process_cmd)
  #     if command in processes or command.splitPath.tail in processes:
  #       let pid = cast[Pid](parseInt(path.splitPath().tail))
  #       result += cast[int](kill(pid, signal))
