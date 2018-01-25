#!/usr/bin/python3

# this script does :
#  - read and parse list of robots and associated controllers
#  - upload xml argos files, binary of experiment and lauching scripts to all the robots in the username folder
#

import json
from subprocess import run
import argparse
import os
import stat

p = argparse.ArgumentParser(description='maker and uploader software for e-pucks, this should be run in the "build" folder where the makefile is')
p.add_argument('-c', '--controller', help='Id of the controller you want to compile/upload (first item of the json file)', required=True)
p.add_argument('-j', '--json', help='config json file to parse to get controllers, lists of robots, options...', required=True)
p.add_argument('-r', '--robots', nargs='*', help="id of one of more robots to send the files to (overides json file data if used)", required=False)


def main():
    args = p.parse_args()

    jsonfile = open(args.json)
    di = json.load(jsonfile)

    upfolder = d['robotfolder']

    try:
        if (args.robots == None or args.robots == []):
            robots = d["id"].split(',')
        else:
            robots = list(args.robots)

        for rob in robots:
            run(["scp -r", upfolder , d["bin"],\
            "%s@%s.%s:%s" % (d["username"],d["baseip"],rob,d["uploadfolder"])], check=True)

    except Exception as e:
        print(e)
        raise


if __name__ == "__main__":
    main()
