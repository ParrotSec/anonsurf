import gintro / gtk


proc makeServiceDetails*(lDNS: Label): Box =
  #[
    Display information about all services
  ]#
  lDNS.text = "LocalHost"
  let
    boxServices = newBox(Orientation.vertical, 3)
  
  boxServices.add(lDNS)

  return boxServices