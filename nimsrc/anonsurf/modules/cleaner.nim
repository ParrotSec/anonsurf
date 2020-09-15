import osproc
# import .. / cli / cores
# import .. / displays / askKill


proc doKillApp*(): int =
  const
    killCommand = "killall -q chrome dropbox skype icedove thunderbird firefox firefox-esr chromium xchat hexchat transmission steam firejail /usr/lib/firefox/firefox"
    cacheCommand = "bleachbit -c adobe_reader.cache chromium.cache chromium.current_session chromium.history elinks.history emesene.cache epiphany.cache firefox.url_history flash.cache flash.cookies google_chrome.cache google_chrome.history  links2.history opera.cache opera.search_history opera.url_history &> /dev/null"
  let
    killResult = execCmd(killCommand)
    cacheResult = execCmd(cacheCommand)
  return killResult + cacheResult
