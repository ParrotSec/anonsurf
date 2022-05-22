import gintro / gtk
import .. / ansurf_icons
import .. / ansurf_gtk_objects


proc w_main_update_ansurf_not_running*(btnRun, btnID, btnStatus, btnRestart: Button, labelDetails: Label, imgStatus: Image) =
  btnRestart.setSensitive(false)
  labelDetails.setText("AnonSurf is not running")
  imgStatus.setFromPixBuf(surfImages.imgSecMed)
  btnRun.label = "Start"
  btnID.setSensitive(false)
  btnStatus.setSensitive(false)


proc w_main_update_tor_not_running*(btnID, btnStatus: Button, labelDetails: Label, imgStatus: Image) =
  imgStatus.setFromPixBuf(surfImages.imgSecLow)
  labelDetails.setText("Tor service doesn't start")
  btnID.setSensitive(false)
  btnStatus.setSensitive(false)


proc w_main_update_tor_ports_error*(btnID, btnStatus: Button, labelDetails: Label, imgStatus: Image) =
  imgStatus.setFromPixBuf(surfImages.imgSecLow)
  labelDetails.setText("Error with Tor ports")
  btnID.setSensitive(false)
  btnStatus.setSensitive(false)


proc w_main_update_btn_run_and_restart*(btnRun, btnRestart: Button) =
  btnRun.label = "Stop"
  btnRestart.setSensitive(true)


proc w_main_update_btn_id_and_status*(btnID, btnStatus: Button) =
  btnID.setSensitive(true)
  btnStatus.setSensitive(true)


proc w_main_update_anonsurf_is_running*(imgStatus: Image, labelDetails: Label) =
  imgStatus.setFromPixBuf(surfImages.imgSecHigh)
  labelDetails.setText("AnonSurf is running")


proc w_main_update_error_dns_port*(imgStatus: Image, labelDetails: Label) =
  imgStatus.setFromPixBuf(surfImages.imgSecMed)
  labelDetails.setText("Error with DNS port")


proc w_main_update_btn_check_ip*(btnIP: Button) =
  if ansurf_workers_myip.running:
    btnIP.setSensitive(false)
  else:
    ansurf_workers_myip.joinThread()
    btnIP.setSensitive(true)


proc w_main_update_all_ports_okay*(portStatus: PortStatus): bool =
  if portStatus.isControlPort and portStatus.isSocksPort and portStatus.isTransPort and
    not portStatus.isReadError:
      return true
  return false
