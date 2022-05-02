type
  callback_kill_apps* = proc(callback_send_msg: callback_send_messenger) {.closure.}
  callback_send_messenger* = proc(title, body: string, code: int)
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
  # MessageCallback* = proc (title: string, body: string, code: int)
  # TorRC* = object
  #   use_bridge*: bool
  #   custom_bridge*: bool
  #   bridge_addr*: string
  #   trans_port*: int
  #   socks_port*: int
  #   control_port*: int
  #   dns_port*: int
  #   sandbox_with_bridge*: bool


let
  bridgePath* = "/etc/anonsurf/bridges.txt"
  defConfPath* = "/etc/anonsurf/anonrc"
