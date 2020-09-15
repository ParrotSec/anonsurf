import osproc
import .. / cli / cores

proc askUser(): bool =
  if not isDesktop:
    return cliUserAsk()
  else:
    discard # TODO use select box of question here


proc doKillAppsFromCli*(): int =
  #[
    Ask if user want to kill dangerous applications.
    If user has DE: Create a pop up with standalone
      gtk application
    Else: create a while loop to ask Y/N question
    This module is for CLI only
  ]#
  const
    killCommand = "killall -q chrome dropbox skype icedove thunderbird firefox firefox-esr chromium xchat hexchat transmission steam firejail /usr/lib/firefox/firefox"
    cacheCommand = "bleachbit -c adobe_reader.cache chromium.cache chromium.current_session chromium.history elinks.history emesene.cache epiphany.cache firefox.url_history flash.cache flash.cookies google_chrome.cache google_chrome.history  links2.history opera.cache opera.search_history opera.url_history &> /dev/null"
  if askUser():
    let
      killResult = execCmd(killCommand)
      cacheResult = execCmd(cacheCommand)
    return killResult + cacheResult


proc doKillAppsFromGUI*(): int =
  #[
    Ask if user want to kill dangerous applications.
    This module for GUI (AnonSurfGTK)
  ]#
  discard
