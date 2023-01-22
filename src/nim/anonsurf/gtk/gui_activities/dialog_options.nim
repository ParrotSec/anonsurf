import gintro / gtk
import strutils
import .. / gui_activities / core_activities
import .. / .. / options / option_objects
import .. / ansurf_gtk_objects
import .. / .. / cores / commons / ansurf_objects
import re
import net


type
  ClickApplyArgs* = object
    configs*: ApplyConfigObj
    dialog*: Dialog


proc checkBridgeAddrFormat(bridge_addr: string): BridgeFormatError =
  let list_bridge_elements = bridge_addr.split(" ")

  if len(list_bridge_elements) != 5:
    return InvalidSyntax

  if list_bridge_elements[0] != "obfs4":
    return InvalidProtocol

  if list_bridge_elements[1].contains(":"):
    let addr_elements = list_bridge_elements[1].split(":")
    if not isIpAddress(addr_elements[0]):
      return InvalidIpAddr
    try:
      let port_number = parseInt(addr_elements[1])
      if port_number < 0 or port_number > 65535:
        return InvalidPortNumber
    except:
      return InvalidPortNumber
  else:
    if not isIpAddress(list_bridge_elements[1]):
      return InvalidIpAddr

  if not match(list_bridge_elements[2], re"[A-Z\d]{40}"):
    return InvalidFingerprint
  if not match(list_bridge_elements[3], re"cert=[\w\d\+\/]{70}"):
    return InvalidCertSyntax
  if not match(list_bridge_elements[4], re"iat-mode=[0-1]"):
    return InvalidIatMode

  return Ok


proc onClickApplyConfig*(b: Button, a: ClickApplyArgs) =
  let
    config = SurfConfig(
      option_sandbox: a.configs.sandboxMode.getActive(),
      option_bridge_mode: cast[BridgeMode](a.configs.bridgeOption.getActive()),
      option_bridge_address: a.configs.bridgeAddr.getText(),
      option_plain_port: cast[PlainPortMode](a.configs.plainPortMode.getActive()),
      option_safe_sock: a.configs.safeSock.getActive()
    )
    bridge_addr_error = checkBridgeAddrFormat(a.configs.bridgeAddr.getText())
  if config.option_bridge_mode == ManualBridge:
    if bridge_addr_error != OK:
      a.configs.callback_show_error("Error " & $bridge_addr_error, "Your bridge address is invalid. Try option \"Auto\" instead.", SecurityLow)
      return
  ansurf_gtk_save_config(config)
  a.configs.callback_show_error("Config applied", "New configurations are saved", SecurityHigh)
  ansurf_gtk_close_dialog(a.dialog)


proc onClickBridgeMode*(c: ComboBoxText, e: Entry) =
  if c.getActive == 2:
    e.setSensitive(true)
  else:
    e.setSensitive(false)


proc onClickCancel*(b: Button, d: Dialog) =
  ansurf_gtk_close_dialog(d)
