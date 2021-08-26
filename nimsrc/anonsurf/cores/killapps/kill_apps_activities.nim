import osproc
import .. / commons / ansurf_types
import strformat
import os

#[
  Try to kill processes by calling `killall` process
  Use bleachbit to clear caches from profiles
  There are some profiles are not supported
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
]#


proc kill_processes(): int =
  const
    killCommand = "killall -q chrome dropbox skype icedove thunderbird firefox firefox-esr chromium xchat hexchat transmission steam firejail /usr/lib/firefox/firefox"
  return execCmd(killCommand)


proc clear_caches(): int =
  const
    path_bleachbit = "/usr/bin/bleachbit"
    cacheCommand = "bleachbit -c adobe_reader.cache chromium.cache chromium.session chromium.history chromium.form_history elinks.history emesene.cache epiphany.cache firefox.cache firefox.crash_reports firefox.url_history firefox.forms flash.cache flash.cookies google_chrome.cache google_chrome.history google_chrome.form_history google_chrome.search_engines google_chrome.session google_earth.temporary_files links2.history opera.cache opera.form_history opera.history &> /dev/null"
  
  if not fileExists(path_bleachbit):
    return -1
  return execCmd(cacheCommand)

proc ansurf_kill_apps*(callback_send_messages: callback_send_messenger) =
  let
    kill_result = kill_processes()
    cache_result = clear_caches()

  if kill_result != 0 and kill_result != 1:
    # kill_result = 0: done
    # kill_resuilt = 1: some apps are not running
    callback_send_messages("AnonSurf kill apps", fmt"Return code {kill_result}. Some apps are failed to kill", 1)
  
  if cache_result == -1:
    callback_send_messages("AnonSurf kill apps", "BleachBit not found. Caches are not removed", 1)
  elif cache_result != 0:
    callback_send_messages("AnonSurf kill apps", fmt"Return code {cache_result}. Some apps are failed to clear cache", 1)
