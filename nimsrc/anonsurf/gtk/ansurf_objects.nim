import gintro / gtk
import .. / cores / ansurf_types


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

var
  # ansurf_start_stop_workers*: Thread[string, callback_kill_apps, callback_send_messenger]
  # ansurf_workers_common_sudo*: Thread[string, callback_send_messenger]
  ansurf_workers_common*: Thread[callback_send_messenger]
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
