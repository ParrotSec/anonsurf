#[
  Handle read, write config
  and transfer config object using pipe
  Tutorial: https://www.youtube.com/watch?v=4xYu2WrygtQ
]#
import option_objects
import parsecfg
import os
import strutils
import osproc
import streams
import json


proc ansurf_options_config_file_exists(): bool =
  return fileExists(ansurf_config_path)


proc set_value(config: var Config, key: string, value: auto) =
  config.setSectionKey("AnonSurfConfig", key, $value)


proc get_value(config: Config, key: string): string =
  return config.getSectionValue("AnonSurfConfig", key)


proc ansurf_options_to_config(user_options: SurfConfig): Config =
  var
    surfOptions = newConfig()
  surfOptions.set_value("use_sandbox", user_options.option_sandbox)
  # surfOptions.set_value("bypass_firewall", user_options.option_bypass_firewall)
  surfOptions.set_value("use_bridge", user_options.option_bridge_mode)
  surfOptions.set_value("bridge_address", user_options.option_bridge_address)
  surfOptions.set_value("safe_sock", user_options.option_safe_sock)
  surfOptions.set_value("plain_port", user_options.option_plain_port)

  return surfOptions


proc ansurf_options_read_config_from_disk(): Config =
  return loadConfig(ansurf_config_path)


proc ansurf_create_default_config*(): SurfConfig =
  let config = SurfConfig(
    option_sandbox: false,
    # option_bypass_firewall: false,
    # option_block_inbound*: bool # TODO it's iptables rules rather than the torrc
    option_bridge_mode: NoBridge,
    option_bridge_address: "",
    option_safe_sock: false,
    option_plain_port: LevelWarn,
  )
  return config


proc ansurf_options_load_config(): SurfConfig =
  try:
    let
      config = ansurf_options_read_config_from_disk()
      ansurf_config = SurfConfig(
        option_sandbox: parseBool(config.get_value("use_sandbox")),
        # option_bypass_firewall: parseBool(config.get_value("bypass_firewall")),
        # option_block_inbound*: bool # TODO it's iptables rules rather than the torrc
        option_bridge_mode: parseEnum[BridgeMode](config.get_value("use_bridge")),
        option_bridge_address: config.get_value("bridge_address"),
        option_safe_sock: parseBool(config.get_value("safe_sock")),
        option_plain_port: parseEnum[PlainPortMode](config.get_value("plain_port"))
      )
    return ansurf_config
  except:
    return ansurf_create_default_config()


proc ansurf_options_handle_load_config*(): SurfConfig =
  var system_config: SurfConfig

  if ansurf_options_config_file_exists():
    system_config = ansurf_options_load_config()
  else:
    system_config = ansurf_create_default_config()
  return system_config


proc ansurf_options_handle_write_config*(options: JsonNode) =
  #[
    Save config from GUI to /etc/anonsurf/anonsurf.cfg
  ]#
  try:
    let
      to_surf_config = SurfConfig(
        option_sandbox: getBool(options["option_sandbox"]),
        option_bridge_mode: parseEnum[BridgeMode](getStr(options["option_bridge_mode"])),
        option_bridge_address: getStr(options["option_bridge_address"]),
        option_safe_sock: getBool(options["option_safe_sock"]),
        option_plain_port: parseEnum[PlainPortMode](getStr(options["option_plain_port"]))
      )
      system_config = ansurf_options_to_config(to_surf_config)
    system_config.writeConfig(ansurf_config_path)
  except:
    echo "Failed to parse config from stdin"


proc ansurf_option_sendp*(user_options: SurfConfig) =
  #[
    Send data using pipe
  ]#
  let
    process = startProcess("/usr/bin/pkexec", args = ["env", "DISPLAY=\"$DISPLAY\"", "XAUTHORITY=\"$XAUTHORITY\"", ansurf_maketorrc_path, "new-config"])
  var
    process_stream = process.inputStream()

  process_stream.write($(%user_options))
  process_stream.close()
  discard waitForExit(process)


proc ansurf_option_readp*() =
  #[
    Read data from pipe
  ]#
  let
    config_from_stdin = readLine(stdin)
    config = parseJson(config_from_stdin)

  ansurf_options_handle_write_config(config)
