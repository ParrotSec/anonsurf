import gintro / [gtk, glib]
import ansurf_gtk_objects
import ansurf_get_status
import refresher / [main_widget_refresher, detail_widget_refresher]


proc updateDetailWidget(args: DetailObjs, myStatus: Status) =
  w_detail_update_dns_status(args.lblDns)

  if myStatus.isAnonSurfBoot:
    w_detail_update_enabled_boot(args.btnBoot, args.lblBoot, args.imgBoot)
  else:
    w_detail_update_disabled_boot(args.btnBoot, args.lblBoot, args.imgBoot)

  if myStatus.isAnonSurfService:
    w_detail_update_label_services(myStatus.isTorService, args.lblServices)
    w_detail_update_label_ports(args.lblPorts)
  else:
    w_detail_update_label_ports_and_services_deactivated(args.lblServices, args.lblPorts)


proc updateMainWidget(args: MainObjs, myStatus: Status) =
  #[
    Always check status of current widget
      to show correct state of buttons
  ]#
  if not myStatus.isAnonSurfService:
    w_main_update_ansurf_not_running(args.btnRun, args.btnID, args.btnStatus, args.btnRestart, args.lDetails, args.imgStatus)
  else:
    w_main_update_btn_run_and_restart(args.btnRun, args.btnRestart)
    # Check status of tor service
    if myStatus.isTorService:
      let myPorts = getStatusPorts()
      # If everything (except DNS port) is okay
      if w_main_update_all_ports_okay(myPorts):
        w_main_update_btn_id_and_status(args.btnID, args.btnStatus)
        # Check DNS
        if myPorts.isDNSPort:
          w_main_update_anonsurf_is_running(args.imgStatus, args.lDetails)
        else:
          w_main_update_error_dns_port(args.imgStatus, args.lDetails)
      else:
        w_main_update_tor_ports_error(args.btnID, args.btnSTatus, args.lDetails, args.imgStatus)
    else:
      w_main_update_tor_not_running(args.btnId, args.btnStatus, args.lDetails, args.imgStatus)

  w_main_update_btn_check_ip(args.btnIP)


proc ansurf_handle_refresh_layouts*(args: RefreshObj): bool =
  #[
    Program is having 2 pages: main and detail
    This handleRefresh check which page is using
    so it update only 1 page for better performance
  ]#
  let
    freshStatus = getSurfStatus()

  if args.stackObjs.getVisibleChildName == "main":
    updateMainWidget(args.mainObjs, freshStatus)
  else:
    updateDetailWidget(args.detailObjs, freshStatus)

  return SOURCE_CONTINUE


proc ansurf_handle_refresh_all*(args: RefreshObj) =
  #[
    Program is having 2 pages: main and detail
    This handleRefresh check which page is using
    so it update only 1 page for better performance
  ]#
  let
    freshStatus = getSurfStatus()

  updateMainWidget(args.mainObjs, freshStatus)
  updateDetailWidget(args.detailObjs, freshStatus)
