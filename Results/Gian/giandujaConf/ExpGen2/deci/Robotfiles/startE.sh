#!/bin/bash
if [ "$1" == "0" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_94393.xml
elif [ "$1" == "1" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_58134.xml
elif [ "$1" == "2" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_16672.xml
elif [ "$1" == "3" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_14671.xml
elif [ "$1" == "4" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_94393.xml
elif [ "$1" == "5" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_14671.xml
elif [ "$1" == "6" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_19890.xml
elif [ "$1" == "7" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_19890.xml
elif [ "$1" == "8" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_46885.xml
elif [ "$1" == "9" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_52388.xml
elif [ "$1" == "10" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_7548.xml
elif [ "$1" == "11" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_7583.xml
elif [ "$1" == "12" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_58134.xml
elif [ "$1" == "13" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_7548.xml
elif [ "$1" == "14" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_79820.xml
elif [ "$1" == "15" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_7548.xml
elif [ "$1" == "16" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_79820.xml
elif [ "$1" == "17" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_19890.xml
elif [ "$1" == "18" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_7583.xml
elif [ "$1" == "19" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_46885.xml
elif [ "$1" == "20" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_16672.xml
elif [ "$1" == "21" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_79820.xml
elif [ "$1" == "22" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_46885.xml
elif [ "$1" == "23" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_94393.xml
elif [ "$1" == "24" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_52388.xml
elif [ "$1" == "25" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_7583.xml
elif [ "$1" == "26" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_decision_visu_14671.xml
elif [ "$1" == "27" ]; then ./automode -i automode_choco -c automodegianduja_decision_visu_58134.xml
elif [ "$1" == "28" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_16672.xml
elif [ "$1" == "29" ]; then ./automode -i automode_gianduja -c automodegianduja_decision_visu_52388.xml
else echo "ERROR: Unknown expe number $1"
fi