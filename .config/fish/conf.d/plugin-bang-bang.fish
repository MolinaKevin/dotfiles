# Bindings para comandos de historia
bind ! __history_previous_command
bind '$' __history_previous_command_arguments

# Configuración para modo insert si se usan las teclas de comando de vi
if test "$fish_key_bindings" = 'fish_vi_key_bindings'
    bind --mode insert ! __history_previous_command
    bind --mode insert '$' __history_previous_command_arguments
end

function _plugin-bang-bang_uninstall --on-event plugin-bang-bang_uninstall
    bind --erase --all !
    bind --erase --all '$'
    functions --erase _plugin-bang-bang_uninstall
end

