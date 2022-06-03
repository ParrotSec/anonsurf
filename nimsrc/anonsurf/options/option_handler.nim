#[
  Handle read, write config
  and transfer config object using pipe
  Tutorial: https://www.youtube.com/watch?v=4xYu2WrygtQ
]#

import posix
import option_objects
import parsecfg
import os
import strutils


proc ansurf_options_config_file_exists(): bool =
  return fileExists(ansurf_config_path)


proc ansurf_options_to_config(user_options: SurfConfig): Config =
  var
    surfOptions = newConfig()
  surfOptions.setSectionKey("", "use_sandbox", $user_options.option_sandbox)
  surfOptions.setSectionKey("", "bypass_firewall", $user_options.option_bypass_firewall)
  surfOptions.setSectionKey("", "use_bridge", $user_options.option_bridge_mode)
  surfOptions.setSectionKey("", "bridge_address", user_options.option_bridge_address)
  return surfOptions


proc ansurf_options_read_config_from_disk(): Config =
  return loadConfig(ansurf_config_path)


proc ansurf_options_load_config(): SurfConfig =
  let
    config = ansurf_options_read_config_from_disk()
    ansurf_config = SurfConfig(
      option_sandbox: parseBool(config.getSectionValue("", "use_sandbox")),
      option_bypass_firewall: parseBool(config.getSectionValue("", "bypass_firewall")),
      # option_block_inbound*: bool # TODO it's iptables rules rather than the torrc
      option_bridge_mode: parseEnum[BridgeMode](config.getSectionValue("", "use_bridge")),
      option_bridge_address: config.getSectionValue("", "bridge_address"),
    )


proc ansurf_create_default_config*(): SurfConfig =
  let config = SurfConfig(
    option_sandbox: true,
    option_bypass_firewall: false,
    # option_block_inbound*: bool # TODO it's iptables rules rather than the torrc
    option_bridge_mode: NoBridge,
    option_bridge_address: "",
  )
  return config


proc ansurf_options_handle_load_config*() =
  var system_config: SurfConfig
  if not ansurf_options_config_file_exists():
    system_config = ansurf_create_default_config()
  else:
    discard # LOAD config here


proc ansurf_options_read_config*(): SurfConfig =
  #[
    Map the config from file into a struct
    should be used by option dialog or
    make-torrc to generate new torrc
  ]#
  discard


proc ansurf_option_sendp*(user_options: SurfConfig) =
  #[
    Send data using pipe
  ]#
  var
    pipe_connector: PipeArray
  if dup2(pipe_connector[1], STDOUT_FILENO) != -1:
    discard pipe_connector[1].close()
    # TODO execute make-torrc to write configs
  else:
    discard # print error


proc ansurf_options_handle_write_config(options: SurfConfig) =
  discard


proc ansurf_option_readp*() =
  #[
    Read data from pipe
  ]#
  var
    pipe_connector: PipeArray
    user_options: SurfConfig

  if read(pipe_connector[0], addr(user_options), sizeof(user_options)) == 0:
    discard pipe_connector[0].close()
    ansurf_options_handle_write_config(user_options)
  else:
    discard
