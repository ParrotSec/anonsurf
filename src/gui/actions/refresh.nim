import gintro / gtk
import .. / .. / utils / status

type
  MainObjs* = ref object
    btnRun*: Button
    btnID*: Button
    btnDetail*: Button
    btnStatus*: Button
    imgStatus*: Image
  DetailObjs* = ref object
    lblAnon*: Label
    lblTor*: Label
    lblDns*: Label
    lblBoot*: Label
    btnBoot*: Button
    btnRestart*: Button
    imgBoot*: Image


proc updateDetail*(args: DetailObjs, myStatus: Status) =
  # AnonSurf is Enabled at boot
  if myStatus.isAnonSurfBoot:
    args.btnBoot.label = "Disable"
    args.lblBoot.setLabel("Enabled at boot")
    args.imgBoot.setFromIconName("security-high", 6)
  else:
    args.btnBoot.label = "Enable"
    args.lblBoot.setLabel("Not Enabled at boot")
    args.imgBoot.setFromIconName("security-low", 6)
  
  # TODO refresh for the sevices


proc updateMain*(args: MainObjs, myStatus: Status) =
  #[
    Always check status of current widget
      to show correct state of buttons
  ]#
  # TODO complex analysis for AnonSurf status and image
  if myStatus.isAnonSurfService == 1:
    args.btnRun.label = "Stop"
    args.btnID.setSensitive(true)
    args.btnDetail.label= "AnonSurf is running"
    args.btnStatus.setSensitive(true)
    args.imgStatus.setFromIconName("security-high", 6) # TODO check actual status
  else:
    args.btnRun.label = "Start"
    args.btnID.setSensitive(false)
    args.btnDetail.label= "AnonSurf is not running"
    args.btnStatus.setSensitive(false)
    args.imgStatus.setFromIconName("security-medium", 6) # TODO check actual status
