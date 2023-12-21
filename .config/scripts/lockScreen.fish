#!/bin/fish

set file "/tmp/screen.jpg";
set out "/tmp/screen.png";

import -window root $file;
convert $file -blur 0x3 $out;
i3lock -i $out --indicator -k;
