#!/usr/bin/python3

# Use to launch designs
# @author: Ken H <me@kenh.fr>

import toml
import argparse
from pathlib import Path
import subprocess as sp

def main(args):
    print("Using conf file: {}".format(args.config_file))
    conf_dict = toml.load(args.config_file)
    
    def search(items, exe):
        for item in items:  
            # print(item)
            if type(item[1]) is dict:
                search(list(item[1].items()), exe)
            else:
                if item[0] == "exec":
                    exe = item[1]
                elif item[0] == "args":
                    if exe == "":
                        print("No executable for args {}".format(item[1]))
                    else:
                        command = "{} {}".format(exe,item[1])
                        print("launch {}".format(command))
                        proc = sp.run(command, shell=True, capture_output=True)
                        print("{} {}".format(proc.stdout.decode("utf-8"),proc.stderr.decode("utf-8")))

    search(list(conf_dict.items()), "")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('config_file', type=Path)
    args = parser.parse_args()
    main(args)

