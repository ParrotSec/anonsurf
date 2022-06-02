import posix
import option_objects


proc ansurf_write_config(user_options: SurfConfig) =
  discard


proc ansurf_option_sendp*(user_options: SurfConfig) =
  #[
    Send data using pipe
  ]#
  var
    pipe_connector: PipeArray
  if dup2(pipe_connector[1], STDOUT_FILENO) != -1:
    discard pipe_connector[1].close()
    # TODO execute make-torrc to write configs
  else:
    discard # print error


proc ansurf_option_readp*() =
  #[
    Read data from pipe
  ]#
  var
    pipe_connector: PipeArray
    user_options: SurfConfig

  if read(pipe_connector[0], addr(user_options), sizeof(user_options)) == 0:
    discard pipe_connector[0].close()
    ansurf_write_config(user_options)
  else:
    discard
