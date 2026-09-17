#!/usr/bin/env fish

# Encuentra la ruta del sensor de temperatura
for i in /sys/bus/platform/devices/coretemp.0/hwmon/hwmon*/temp*_input
    if test -f $i
        echo $i
        break
    end
end

