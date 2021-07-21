import osproc
import gintro / [gtk, gobject]


proc an_kill_apps*(): int =
  const
    killCommand = "killall -q chrome dropbox skype icedove thunderbird firefox firefox-esr chromium xchat hexchat transmission steam firejail /usr/lib/firefox/firefox"
    cacheCommand = "bleachbit -c adobe_reader.cache chromium.cache chromium.session chromium.history chromium.form_history elinks.history emesene.cache epiphany.cache firefox.cache firefox.crash_reports firefox.url_history firefox.forms flash.cache flash.cookies google_chrome.cache google_chrome.history google_chrome.form_history google_chrome.search_engines google_chrome.session google_earth.temporary_files links2.history opera.cache opera.form_history opera.history &> /dev/null"
  let
    killResult = execCmd(killCommand)
    cacheResult = execCmd(cacheCommand)
  return killResult + cacheResult


proc cli_kill_apps*(msg_callback: proc) =
  while true:
    echo("[?] Do you want to kill dangerous applications? (Y/n)")
    let input = readLine(stdin)
    if input == "y" or input == "Y":
      if an_kill_apps() == 0:
        msg_callback("Apps killer", "Success", 0)
      else:
        msg_callback("Apps killer", "Error while killing apps", 1)
    elif input == "n" or input == "N":
      return
    else:
      msg_callback("Apps killer", "Invalid option! Please use Y / N", 1)


# proc gtk_kill_apps_window*() =
#   gtk.init()
#   let
#     mainBoard = newWindow()
#     boxMainWindow = boxAskKillAppsCli()
  
#   mainBoard.setResizable(false)
#   mainBoard.title = "Kill dangerous application"
#   mainBoard.setPosition(WindowPosition.center)
#   mainBoard.add(boxMainWindow)
#   mainBoard.setBorderWidth(3)

#   mainBoard.showAll()
#   mainBoard.connect("destroy", onExit)
#   gtk.main()

# proc gtk_kill_apps*() =
