import system

const
  ansurf_config_path* = "/etc/anonsurf/anonsurf.cfg"
  ansurf_list_bridges* = "/etc/anonsurf/bridges.txt"
  ansurf_nyx_config_path* = "/etc/anonsurf/nyxrc"
  ansurf_torrc_default_path* = "/etc/tor/torrc"
  ansurf_torrc_backup_path* = "/etc/tor/torrc.bak"
  ansurf_onion_config_path* = "/etc/anonsurf/onion.pac"
  ansurf_onion_system_path* = "/etc/tor/onion.pac"
  ansurf_config_torrc_default* = staticRead("../../../configs/torrc.base")
  ansurf_config_torrc_bridge* = staticRead("../../../configs/bridgerc.base")
  ansurf_maketorrc_path* = "/usr/lib/anonsurf/make-torrc"

type
  ConfigTuple* = tuple[option_sandbox: string, option_bridge_mode: string, option_bridge_address: string]
  BridgeMode* = enum
    NoBridge, AutoBridge, ManualBridge
  SurfConfig* = object
    option_sandbox*: bool
    # option_bypass_firewall*: bool
    # option_block_inbound*: bool # TODO it's iptables rules rather than the torrc
    option_bridge_mode*: BridgeMode
    option_bridge_address*: string
