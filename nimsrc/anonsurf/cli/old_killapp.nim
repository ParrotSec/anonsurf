import .. / cli / cores
import .. / displays / askKill
import .. /  modules / cleaner


proc doKillAppsFromCli*(): int =
  #[
    Ask if user want to kill dangerous applications.
    If user has DE: Create a pop up with standalone
      gtk application
    Else: create a while loop to ask Y/N question
    This module is for CLI only
  ]#
  if not isDesktop:
    if cliUserAsk():
      return doKillApp()
    else:
      return -1
  else:
    initAskCli()
    return -1
