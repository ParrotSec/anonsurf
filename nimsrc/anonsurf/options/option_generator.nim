import random
import strutils
import osproc
import option_objects


randomize()


proc ansurf_options_gen_random_password*(): string =
  #[
    Generate random string
  ]#
  let randLen = rand(8..16)
  var password = ""
  for i in 0 .. randLen:
    password = password & sample(strutils.Letters)

  return password


proc ansurf_options_parse_tor_hash*(password: string): string =
  #[
    Generate tor hash by calling tor command
  ]#
  let output = execProcess("tor --hash-password \"" & password & "\"")
  # The hash is usually at the end of list
  # all other lines are comments
  # We do for loop to make sure there is no mistake
  for line in output.split("\n"):
    if line.startsWith("16:"):
      return line


proc ansurf_options_get_random_bridge(): string =
  #[
    Read the list from official list
    Random selecting from the list
  ]#
  # New list from https://trac.torproject.org/projects/tor/wiki/doc/TorBrowser/DefaultBridges

  var
    list_bridge_addrs: seq[string]

  for line in lines(ansurf_list_bridges):
    if not line.startsWith("#") and not isEmptyOrWhitespace(line):
      list_bridge_addrs.add(line)

  return sample(list_bridge_addrs)


proc option_enable_sandbox_mode(settings: var string) =
  settings &= "\n# Enable sandbox\n"
  settings &= "Sandbox 1\n"


# proc option_bypass_firewall(settings: var string) =
#   # https://2019.www.torproject.org/docs/tor-manual.html.en
#   # TODO check ReachableDirAddresses or ReachableORAddresses
#   settings &= "\n# Set bypass firewall\n"
#   settings &= "FascistFirewall 1\n"


proc option_enable_bridge(settings: var string) =
  settings &= "\n# Enable bridge mode\n"
  settings &= "UseBridges 1\n"


proc option_set_bridge_addr(settings: var string, bridge_addr: string) =
  # https://sigvids.gitlab.io/create-tor-private-obfs4-bridges.html
  # https://community.torproject.org/relay/setup/bridge/debian-ubuntu/
  settings &= "Bridge " & bridge_addr & "\n"


proc option_set_torrc_hash(settings: var string, hash: string) =
  settings &= "HashedControlPassword " & hash & "\n"


proc ansurf_options_generate_common_settings(settings: var string) =
  let
    random_passwd = ansurf_options_gen_random_password()
    tor_hash = ansurf_options_parse_tor_hash(random_passwd)

  settings = ansurf_config_torrc_default
  settings.option_set_torrc_hash(tor_hash)


proc ansurf_options_add_bridge_options(settings: var string, user_options: SurfConfig) =
  settings &= "\n#Bridge mode settings\n" & ansurf_config_torrc_bridge
  var
      bridge_addr: string

  if user_options.option_bridge_mode == AutoBridge:
    bridge_addr = ansurf_options_get_random_bridge()
  else:
    bridge_addr = user_options.option_bridge_address # TODO check bridge addr format

  settings.option_enable_bridge()
  settings.option_set_bridge_addr(bridge_addr)


proc ansurf_options_generate_torrc*(user_options: SurfConfig): string =
  var
    settings: string

  settings.ansurf_options_generate_common_settings()

  # if user_options.option_bypass_firewall:
  #     settings.option_bypass_firewall()
  if user_options.option_bridge_mode == NoBridge:
    if user_options.option_sandbox:
      settings.option_enable_sandbox_mode()
  else:
    settings.ansurf_options_add_bridge_options(user_options)

  return settings
