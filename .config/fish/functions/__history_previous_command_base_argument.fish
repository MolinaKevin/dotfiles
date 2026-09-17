# Función para copiar el último argumento
function __history_previous_command_base_argument
    # Obtiene la línea de comando anterior
    set full_command $history[1]

    # Separa la línea en argumentos
    set last_arg (string split ' ' $full_command)

    # Verifica que haya argumentos
    if test (count $last_arg) -eq 0
        return 1
    end

    # Obtiene el último argumento
    set last_arg $last_arg[-1]

    # Expande el argumento a su ruta absoluta, manejando la tilde
    if test "$last_arg" = "~"
        set last_arg $HOME
    else
        set last_arg (string replace '~' $HOME $last_arg)
    end

    # Verifica si la ruta existe antes de usar realpath
    if not test -e $last_arg
        echo "La ruta especificada no existe."
        return 1
    end

    # Obtiene la ruta absoluta
    set last_arg (realpath $last_arg)

    # Verifica si el argumento es un archivo o un directorio
    if test -d $last_arg
        # Si es un directorio, quita el último nivel
        set new_path (dirname $last_arg)
    else if test -f $last_arg
        # Si es un archivo, quita el nivel del archivo y luego otro nivel
        set new_path (dirname $last_arg)
    else
        echo "El último argumento no es una ruta válida."
        return 1
    end

    # Verifica que new_path no esté vacío antes de copiar
    if test -n "$new_path"
        echo $new_path | xclip -selection clipboard
    else
        return 1
    end
end

