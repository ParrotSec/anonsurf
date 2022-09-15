import gintro / gtk
import .. / ansurf_icons
import .. / .. / cores / commons / dns_utils
import .. / ansurf_get_status

const
  title_dns = "DNS: "
  title_service = "Servc: "
  title_ports = "Ports: "


proc set_markup_green(label: Label, title, msg: string) =
  label.setMarkup(cstring(title & "<b><span background=\"#333333\" foreground=\"#00FF00\"> " & msg & "</span></b>"))


proc set_markup_red(label: Label, title, msg: string) =
  label.setMarkup(cstring(title & "<b><span background=\"#333333\" foreground=\"#FF0000\"> " & msg & "</span></b>"))


proc set_markup_cyan(label: Label, title, msg: string) =
  label.setMarkup(cstring(title & "<b><span background=\"#333333\" foreground=\"#00FFFF\"> " & msg & "</span></b>"))


proc w_detail_update_enabled_boot*(btn: Button, label: Label, img: Image) =
  btn.label = "Disable"
  label.setLabel("Enabled at boot")
  img.setFromPixbuf(surfImages.imgBootOn)


proc w_detail_update_disabled_boot*(btn: Button, label: Label, img: Image) =
  btn.label = "Enable"
  label.setLabel("Not enabled at boot")
  img.setFromPixbuf(surfImages.imgBootOn)


proc w_detail_update_dns_status*(labelDNS: Label) =
  # TODO remove all text shadow
  let dns_status = dnsStatusCheck()
  if dns_status.err == ERR_TOR:
    let myPorts = getStatusPorts()
    if myPorts.isReadError:
      labelDNS.set_markup_red(title_dns, "Can't read Tor config")
    elif myPorts.isDNSPort:
      labelDNS.set_markup_green(title_dns, "Tor DNS")
    else:
      labelDNS.set_markup_red(title_dns, "Can't bind port")
  elif dns_status.err == ERR_LOCAL_HOST:
    labelDNS.set_markup_red(title_dns, "LocalHost")
  elif dns_status.err == ERR_FILE_EMPTY:
    labelDNS.set_markup_red(title_dns, "resolv.conf is empty")
  elif dns_status.err == ERR_FILE_NOT_FOUND:
    labelDNS.set_markup_red(title_dns, "resolv.conf not found")
  elif dns_status.err == ERR_UNKNOWN:
    labelDNS.set_markup_red(title_dns, "Unknown error")
  else:
    if dns_status.is_static:
      labelDNS.set_markup_cyan(title_dns, "Custom servers")
    else:
      labelDNS.set_markup_cyan(title_dns, "resolvconf settings")


proc w_detail_update_label_ports_and_services_deactivated*(labelServices, labelPorts: Label) =
  labelServices.set_markup_cyan(title_service, "Deactivated")
  labelPorts.set_markup_cyan(title_ports, "Deactivated")


proc w_detail_update_label_services*(isTorService: bool, labelServices: Label) =
  if isTorService:
    labelServices.set_markup_green(title_service, "Activated")
  else:
    labelServices.set_markup_red(title_service, "Tor is not running")


proc w_detail_update_label_ports*(labelPorts: Label) =
  let portStatus = getStatusPorts()
  if portStatus.isReadError:
    labelPorts.set_markup_red(title_ports, "Parse torrc failed")
  else:
    case int(portStatus.isControlPort) + int(portStatus.isSocksPort) + int(portStatus.isTransPort)
    of 3:
      labelPorts.set_markup_green(title_ports, "Activated")
    else:
      labelPorts.set_markup_red(title_ports, "Can't bind ports")
