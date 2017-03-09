#!/usr/bin/python3
# a script to ssh multiple servers over multiple tmux panes

import json
from subprocess import run
import argparse
import os

p = argparse.ArgumentParser(description='multiple tmux opener and synchroniser based on json file')
p.add_argument('-c', '--controller', help='Id of the controller you want to compile/upload (first item of the json file)', required=True)
p.add_argument('-j', '--json', help='config json file to parse to get controllers, lists of robots, options...', required=True)


def main():
    args = p.parse_args()

    jsonfile = open(args.json)
    di = json.load(jsonfile)
    try:
        d = di[args.controller]
    except KeyError:
        print("Controller not found in json file, stopping.")
        raise

    try:
        robots = d["id"].split(',')
        run("tmux new -s epucks -d", shell=True)
        run('tmux send-keys -t epucks "ssh %s@%s.%s" Enter'\
        % ( d["username"],d["baseip"],robots[0] ), shell=True, check=True )

        for rob in robots[1:]:
            run('tmux split-window -h -t epucks "ssh %s@%s.%s"' % ( d["username"],d["baseip"],rob ), shell=True, check=True)
            run('tmux select-layout tiled', shell=True)

        run('tmux set-window-option synchronize-panes on', shell=True) #sync typing in all panes
        run('tmux a', shell=True)
    except Exception as e:
        print(e)
        raise

if __name__ == "__main__":
    main()
