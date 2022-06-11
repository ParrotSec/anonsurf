import options / [option_objects, option_generator, option_handler]
import os
# TODO print
# TODO help banner if needed

proc maketorrc_remove_nyx() =
  if not tryRemoveFile(ansurf_nyx_config_path):
    echo "Error remove file"


proc maketorrc_restore_torrc_backup() =
  try:
    moveFile(ansurf_torrc_backup_path, ansurf_torrc_default_path)
  except:
    echo "Error while restore torrc backup"


proc maketorrc_create_nyx() =
  let password = ansurf_options_gen_random_password()
  try:
    writeFile(ansurf_nyx_config_path, "password " & password & "\n")
    echo "New nyxrc created"
  except:
    echo "Error write new nyxrc"


proc maketorrc_create_torrc_backup() =
  try:
    copyFile(ansurf_torrc_default_path, ansurf_torrc_backup_path)
  except:
    echo "Failed to create new torrc backup"


proc maketorrc_create_new_config() =
  let
    config = ansurf_options_handle_load_config()
    config_to_torrc = ansurf_options_generate_torrc(config)

  maketorrc_create_nyx()
  maketorrc_create_torrc_backup()
  try:
    writeFile(ansurf_torrc_default_path, config_to_torrc)
  except:
    echo "Error failed to create new torrc"


proc maketorrc_restore_system_config() =
  maketorrc_remove_nyx()
  maketorrc_restore_torrc_backup()


proc maketorrc_get_new_config() =
  ansurf_option_readp()


proc main() =
  if paramCount() == 0:
    #[
      In old version, we are having the same logic
      No need to change bash file for this
    ]#
    maketorrc_create_new_config()
    return
  if paramCount() != 1:
    return
  if paramStr(1) == "restore":
    maketorrc_restore_system_config()
  elif paramStr(1) == "new-config":
    maketorrc_get_new_config()
  elif paramStr(1) == "new-torrc":
    maketorrc_create_new_config()

main()
