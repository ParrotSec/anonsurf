let
  ansurf_config_path* = "/etc/anonsurf/anonsurf.cfg"
  ansurf_list_bridges* = "/etc/anonsurf/bridge.txt"

type
  BridgeMode* = enum
    NoBridge, Auto, Manual
  PipeArray* = array[2, cint]
  SurfConfig* = object
    option_sandbox*: bool
    option_bypass_firewall*: bool
    option_block_inbound*: bool # TODO it's iptables rules rather than the torrc
    option_bridge_mode*: BridgeMode
    option_bridge_address*: string
