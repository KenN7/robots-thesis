#!/usr/bin/python3
import os
import sys
import subprocess as sp
import argparse
import re
import time
import toml
from pathlib import Path
from evaluate import slugify,Launcher

# This script get data from series of runs launched with evaluate

def main(args):
    print("Using conf file: {}".format(args.config))
    conf_dict = toml.load(args.config)
    launchers = conf_dict.get('launchers')
    if os.path.isfile(Path(args.output)):
        raise Exception('File {} exists'.format(args.output))
    print('Using output file: {}'.format(args.output))
    output = open(Path(args.output),'w') 
    output.write('"Method","Mission","Options","Seed","Score"\n')

    for item in conf_dict.get('experiments').items():
        if item[1].get('launcher') and item[1].get('xml') \
                and item[1].get('controllers') and item[1].get('mission') \
                and item[1].get('options'):

            if not os.path.isdir(Path(args.input)):
                raise Exception('Input folder does not exist.')
            input_folder = Path(args.input)

            jobname = slugify("{}-{}-{}-".format( item[1].get('launcher'),item[1].get('mission'),item[1].get('options') ))
            regex_mission = re.compile(r'{}(\d+)'.format(jobname))
            folders = [ folder for folder in os.listdir(input_folder) if regex_mission.match(folder) ] 
            launcher = Launcher.get_launcher(launchers.get(item[1].get('launcher')))
            
            for i,folder in enumerate(folders):
                print("Processing folder: {}".format(folder))
                seed = regex_mission.search(folder).group(1)
                with open(Path(args.input) / Path(folder) / "stdout.log", 'r') as file_log:
                    log = file_log.read()
                    score = launcher.get_score(log).group(1)
                output.write('"{}","{}","{}","{}","{}"\n'.format(item[1].get('launcher'), item[1].get('mission'), item[1].get('options'), seed, score))
    print('End.')
    output.close()



if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--config', help='config file (toml)')
    parser.add_argument('-i', '--input', help='Input folder where all runs were stored')
    parser.add_argument('-o', '--output', help='Output file')
    args = parser.parse_args()
    main(args)
