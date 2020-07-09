import gintro / [gtk, notify]
import ../../ modules / myip
import strutils


proc onClickCheckIP*(b: Button) =
  #[
    Display IP when user click on CheckIP button
    Show the information in system's notification
  ]#

  # let
  #   labelIP = newLabel(checkIPwTorServer())
  #   ipDialog = newdialog()
  #   area = ipDialog.getContentArea()
  
  # ipDialog.setTitle("My IP Address")
  # area.add(labelIP)

  # ipDialog.showAll()
  discard init("My IP Address")
  let
    ipInfo = checkIPwTorServer()
  
  # If program has error while getting IP address
  if ipInfo[0].startsWith("Error"):
    let ipNotify = newNotification(ipInfo[0], ipInfo[1], "error") # security-low
    discard ipNotify.show()
  # If program runs but user didn't connect to tor
  elif ipInfo[0].startsWith("Sorry"):
    let ipNotify = newNotification(ipInfo[0], ipInfo[1], "security-medium")
    discard ipNotify.show()
  # Connected to tor
  else:
    let ipNotify = newNotification(ipInfo[0], ipInfo[1], "security-high")
    discard ipNotify.show()
  