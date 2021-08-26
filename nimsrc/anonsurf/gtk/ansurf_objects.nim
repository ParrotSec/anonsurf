import gintro / gtk


type
  MainObjs* = ref object
    btnRun*: Button
    btnID*: Button
    btnDetail*: Button
    btnStatus*: Button
    btnIP*: Button
    lDetails*: Label
    imgStatus*: Image
    btnRestart*: Button
  DetailObjs* = ref object
    lblServices*: Label
    lblPorts*: Label
    lblDns*: Label
    lblBoot*: Label
    btnBoot*: Button
    imgBoot*: Image
  RefreshObj* = ref object
    mainObjs*: MainObjs
    detailObjs*: DetailObjs
    stackObjs*: Stack
  Status* = ref object
    isAnonSurfService*: int
    isTorService*: int
    isAnonSurfBoot*: bool
  PortStatus* = object
    isReadError*: bool
    isControlPort*: bool
    isDNSPort*: bool
    isSocksPort*: bool
    isTransPort*: bool