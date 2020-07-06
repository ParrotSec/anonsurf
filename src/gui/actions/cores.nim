import gintro / gtk


proc onClickBack*(b: Button, s: Stack) =
  #[
    Return main widget from current page
  ]#
  s.setVisibleChildName("main")


proc onClickDetail*(b: Button, s: Stack) =
  #[
    Display status page
  ]#
  s.setVisibleChildName("detail")


proc onClickExit*(b: Button) =
  #[
    Close program by click on exit button
  ]#
  mainQuit()


proc onClickStop*(w: Window) =
  #[
    Close program by click on title bar
  ]#
  mainQuit()
