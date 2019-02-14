#!/bin/sh
if [ "$1" == "0" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_aggregation_63036.xml
elif [ "$1" == "1" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_aggregation_4377.xml
elif [ "$1" == "2" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_aggregation_19553.xml
elif [ "$1" == "3" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_aggregation_72184.xml
elif [ "$1" == "4" ]; then ./automode -i automode_gianduja -c automodegianduja_aggregation_4377.xml
elif [ "$1" == "5" ]; then ./automode -i automode_gianduja -c automodegianduja_aggregation_67310.xml
elif [ "$1" == "6" ]; then ./automode -i automode_gianduja -c automodegianduja_aggregation_45059.xml
elif [ "$1" == "7" ]; then ./automode -i automode_gianduja -c automodegianduja_aggregation_77622.xml
elif [ "$1" == "8" ]; then ./automode -i automode_gianduja -c automodegianduja_aggregation_97793.xml
elif [ "$1" == "9" ]; then ./automode -i automode_gianduja -c automodegianduja_aggregation_63036.xml
elif [ "$1" == "10" ]; then ./automode -i automode_gianduja -c automodegianduja_aggregation_8329.xml
elif [ "$1" == "11" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_aggregation_45059.xml
elif [ "$1" == "12" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_aggregation_8329.xml
elif [ "$1" == "13" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_aggregation_70157.xml
elif [ "$1" == "14" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_aggregation_97793.xml
elif [ "$1" == "15" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_aggregation_67310.xml
elif [ "$1" == "16" ]; then ./automode -i automode_gianduja -c automodegianduja_aggregation_70157.xml
elif [ "$1" == "17" ]; then ./automode -i automode_gianduja -c automodegianduja_aggregation_72184.xml
elif [ "$1" == "18" ]; then ./epuck_nn -i epuck_nn_controller -c automodegianduja_aggregation_77622.xml
elif [ "$1" == "19" ]; then ./automode -i automode_gianduja -c automodegianduja_aggregation_19553.xml
else echo "ERROR: Unknown expe number $1"
fi