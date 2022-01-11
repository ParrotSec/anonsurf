import osproc
import .. / commons / ansurf_types
# import strformat
# import os

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


proc ansurf_kill_apps*(callback_send_messages: callback_send_messenger) =
  const
    killScript = "/usr/lib/anonsurf/safekill"
  discard execCmd("bash " & killScript)
