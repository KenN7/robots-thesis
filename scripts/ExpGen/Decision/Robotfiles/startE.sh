#!/bin/bash
if [ "$1" == "0" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_98128.xml
elif [ "$1" == "1" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_5081.xml
elif [ "$1" == "2" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_96043.xml
elif [ "$1" == "3" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_37383.xml
elif [ "$1" == "4" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_51028.xml
elif [ "$1" == "5" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_37383.xml
elif [ "$1" == "6" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_51028.xml
elif [ "$1" == "7" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_9221.xml
elif [ "$1" == "8" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_98128.xml
elif [ "$1" == "9" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_9221.xml
elif [ "$1" == "10" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_78246.xml
elif [ "$1" == "11" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_95415.xml
elif [ "$1" == "12" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_37383.xml
elif [ "$1" == "13" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_95415.xml
elif [ "$1" == "14" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_34385.xml
elif [ "$1" == "15" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_28832.xml
elif [ "$1" == "16" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_9221.xml
elif [ "$1" == "17" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_28832.xml
elif [ "$1" == "18" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_34385.xml
elif [ "$1" == "19" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_28832.xml
elif [ "$1" == "20" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_78246.xml
elif [ "$1" == "21" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_95415.xml
elif [ "$1" == "22" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_98128.xml
elif [ "$1" == "23" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_96043.xml
elif [ "$1" == "24" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_5081.xml
elif [ "$1" == "25" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_34385.xml
elif [ "$1" == "26" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_96043.xml
elif [ "$1" == "27" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_78246.xml
elif [ "$1" == "28" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_5081.xml
elif [ "$1" == "29" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_51028.xml
else echo "ERROR: Unknown expe number $1"
fi