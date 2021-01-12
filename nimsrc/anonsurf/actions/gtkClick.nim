import gintro / gtk
import actMainPage


proc onClickDetail*(b: Button, s: Stack) =
  #[
    Display details widget or main widget
  ]#
  if b.label == "Details":
    s.setVisibleChildName("detail")
    b.label = "Back"
  else:
    s.setVisibleChildName("main")
    b.label = "Details"


proc onClickExit*(b: Button) =
  #[
    Close program by click on exit button
  ]#
  channel.close()
  mainQuit()


proc onClickStop*(w: Window) =
  #[
    Close program by click on title bar
  ]#
  channel.close()
  mainQuit()
