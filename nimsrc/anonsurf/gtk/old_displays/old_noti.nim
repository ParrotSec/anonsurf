import gintro / notify


proc sendNotify*(sumary, body, icon: string) =
  #[
    Display IP when user click on CheckIP button
    Show the information in system's notification
  ]#

  discard init("AnonSurf GUI notification")
  let ipNotify = newNotification(sumary, body, icon) # security-low
  discard ipNotify.show()
