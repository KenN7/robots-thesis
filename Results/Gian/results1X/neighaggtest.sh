#!/bin/bash


for VAR in 1 3 4 8
do
        OUTPUT2=$(/home/ken/depots/neat-argos3/bin/NEAT-launch -c /home/ken/depots/neat-argos3/experiments/automodegianduja_aggregation.xml -s 1234 -g /home/ken/depots/robots-thesis/scripts/results1X/results-evo-oldneatagg1.21/gen_champ_$VAR 2>&1)
        OUTPUT1=$(/home/ken/depots/old_gian/bin/evostick_launch -c /home/ken/depots/old_gian/experiments/automodegianduja_aggregation.xml -s 1234 -g /home/ken/depots/robots-thesis/scripts/results1X/results-evo-oldneatagg1.21/gen_champ_$VAR 2>&1)

        SCORE1=$(echo ${OUTPUT1} | grep -o -E 'Score [-+0-9.e]+' | cut -d ' ' -f2)
        SCORE2=$(echo ${OUTPUT2} | grep -o -E 'Score [-+0-9.e]+' | cut -d ' ' -f2)
        echo "old: $SCORE1, new: $SCORE2, diff: $(($SCORE1-$SCORE2))"
done
