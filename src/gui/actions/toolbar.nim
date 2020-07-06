import gintro / gtk
import ../../ modules / myip


proc onClickCheckIP*(b: Button) =
  #[
    Display IP when user click on CheckIP button
  ]#

  let
    labelIP = newLabel(checkIPwTorServer())
    ipDialog = newdialog()
    area = ipDialog.getContentArea()
  
  ipDialog.setTitle("My IP Address")
  area.add(labelIP)

  ipDialog.showAll()