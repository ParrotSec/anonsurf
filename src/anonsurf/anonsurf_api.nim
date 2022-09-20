import cores / [check_status, parse_options]


proc is_anonsurf_running*(): bool {.exportc.} =
  return status_check_service_run("anonsurfd")
