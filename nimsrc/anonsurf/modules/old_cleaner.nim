import osproc
# import .. / cli / cores
# import .. / displays / askKill


proc doKillApp*(): int =
  const
    killCommand = "killall -q chrome dropbox skype icedove thunderbird firefox firefox-esr chromium xchat hexchat transmission steam firejail /usr/lib/firefox/firefox"
    cacheCommand = "bleachbit -c adobe_reader.cache chromium.cache chromium.session chromium.history chromium.form_history elinks.history emesene.cache epiphany.cache firefox.cache firefox.crash_reports firefox.url_history firefox.forms flash.cache flash.cookies google_chrome.cache google_chrome.history google_chrome.form_history google_chrome.search_engines google_chrome.session google_earth.temporary_files links2.history opera.cache opera.form_history opera.history &> /dev/null"
  let
    killResult = execCmd(killCommand)
    cacheResult = execCmd(cacheCommand)
  return killResult + cacheResult
