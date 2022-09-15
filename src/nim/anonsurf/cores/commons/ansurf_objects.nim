type
  TorConfig* = object
    fileErr*: bool # Error while reading file
    controlPort*: string
    transPort*: string
    socksPort*: string
    dnsPort*: string
  AnonOptions* = object
    use_bridge*: bool
    custom_bridge*: bool
    bridge_addr*: string
  StatusImg* = enum
    SecurityHigh, SecurityMedium, SecurityLow, SecurityInfo

  callback_send_messenger* = proc(title, body: string, code: StatusImg)
  callback_kill_apps* = proc(callback_send_msg: callback_send_messenger) {.closure.}

let
  bridgePath* = "/etc/anonsurf/bridges.txt"
  defConfPath* = "/etc/anonsurf/anonrc"
