#!/bin/bash
if [ "$1" == "0" ]; then exec argos3 -c /home/ken/depots/robots-thesis/scripts/ExpGen/Stop/Robotfiles/automodegianduja_stop_visu_95415.xml
elif [ "$1" == "29" ]; then exec argos3 -c /home/ken/depots/robots-thesis/scripts/ExpGen/Stop/Robotfiles/automodegianduja_stop_visu_51028.xml
else echo "ERROR: Unknown expe number $1"
fi

