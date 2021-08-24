type
  callback_kill_apps* = proc(callback_send_msg: callback_send_messenger) {.closure.}
  callback_send_messenger* = proc(title, body: string, code: int)