import gintro / gtk
import .. / cores / commons / ansurf_types


type
  MainObjs* = ref object
    btnRun*: Button
    btnID*: Button
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
  MenuObj* = ref object
    menuRun*: MenuItem
    menuRestart*: MenuItem
    menuStatus*: MenuItem
  RefreshObj* = ref object
    mainObjs*: MainObjs
    detailObjs*: DetailObjs
    stackObjs*: Stack
  Status* = ref object
    isAnonSurfService*: bool
    isTorService*: bool
    isAnonSurfBoot*: bool
  PortStatus* = object
    isReadError*: bool
    isControlPort*: bool
    isDNSPort*: bool
    isSocksPort*: bool
    isTransPort*: bool

#[
  The workers are meant to run start / stop / restart / ... without hanging main gui
  The workers_myip is the same worker but different variable
    so when we use refresher, we can disable this button only
]#
var
  ansurf_workers_common*: Thread[callback_send_messenger]
  ansurf_workers_myip*: Thread[callback_send_messenger]
  # worker*: Thread[void]
#   MyIP* = object
#     thisAddr*: string
#     isUnderTor*: string
#     iconName*: string
# var
#   worker*: system.Thread[void]
#   channel*: Channel[MyIP]

# var
#   retCode*: Channel[int]
