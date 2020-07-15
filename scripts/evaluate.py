#!/usr/bin/python3
import os
import sys
import subprocess as sp
import argparse
import re
import time
import toml
from pathlib import Path

# This script launches some series of runs with options

JOB_SCRIPT = """#!/bin/bash
#$ -N {jobname}
#$ -l {machine}
#$ -l {queue}
#$ -m a
#      b     Mail is sent at the beginning of the job.
#      e     Mail is sent at the end of the job.
#      a     Mail is sent when the job is aborted or rescheduled.
#      s     Mail is sent when the job is suspended.
#$ -o {execdir}/stdout.log
#$ -e {execdir}/stderr.log
#$ -cwd
#$ -pe mpi {nbjob}
#$ -binding linear:256
export PATH
export LD_LIBRARY_PATH=/lustre/home/fpagnozzi/gcc91/lib64/:/home/khasselmann/argos3-dist/lib/argos3:/opt/gridengine/lib/lx-amd64:/opt/openmpi/lib
USERNAME=`whoami`
COMMAND={command}
cd {execdir}
echo "-> {command}"
eval {command}
if [ $? -eq 0 ]
then
  echo "Success!"
  exit 0
else
  echo "Fail!"
  exit 1
fi
"""

class Launcher:
    def __init__(self, launcher):
        self.exe = launcher.get('exe')
        self.regex = re.compile(launcher.get('regex'))

    @staticmethod
    def get_launcher(launcher):
        if launcher.get('type') == 'auto':
            return AutoLauncher(launcher)
        elif launcher.get('type') == 'neat':
            return NeatLauncher(launcher)

    def command(self, args):
        raise Exception("command method not implemented.")

    def execute(self, jobdata):
        print('executing..')
        # print(jobdata)
        # stdout = sp.check_output('sed -e "s/i/i/"', input=JOB_SCRIPT.format(**jobdata), universal_newlines=True, shell=True, stderr=sp.STDOUT)
        stdout = sp.check_output('qsub -v PATH', input=JOB_SCRIPT.format(**jobdata), universal_newlines=True, shell=True, stderr=sp.STDOUT)
        print(stdout)
        
    def get_score(self, log):
        return self.regex.search(log)
    
class AutoLauncher(Launcher):
    def command(self, args):
        return "{} -s {} -c {} --fsm-config {}".format(self.exe,args.get('seed'),args.get('xml'),args.get('controller'))

class NeatLauncher(Launcher):
    def command(self,args):
        return "{} -s {} -c {} -g {}".format(self.exe,args.get('seed'),args.get('xml'),args.get('controller'))


def slugify(text):
    return re.sub(r'[\W_]+', '-', text.lower())

def main(args):
    print("Using conf file: {}".format(args.config))
    conf_dict = toml.load(args.config)
    launchers = conf_dict.get('launchers')
    for item in conf_dict.get('experiments').items():
        if item[1].get('launcher') and item[1].get('xml') \
                and item[1].get('controllers') and item[1].get('mission') \
                and item[1].get('options'):
            controllers = item[1].get('controllers')
            if os.path.isdir(Path(controllers)):
                input_controllers = os.listdir(Path(controllers))
            elif os.path.isfile(Path(controllers)):
                with open(Path(controllers),'r') as input_file:
                    input_controllers = input_file.readlines()
            else:
                raise Exception('No input controllers {}'.format(controllers))

            if not os.path.isdir(Path(args.output)):
                raise Exception('Execution folder does not exist.')
            execution_folder = Path(args.output)

            with open(Path(conf_dict.get('seeds')),'r') as seed_file:
                seeds = [ int(seed) for seed in seed_file ]

            launcher = Launcher.get_launcher(launchers.get(item[1].get('launcher'))) 
            for i,controller in enumerate(input_controllers):
                jobname = slugify("{}-{}-{}-{}".format( item[1].get('launcher'),item[1].get('mission'),item[1].get('options'),seeds[i] ))
                execdir = execution_folder / jobname
                execdir.mkdir()
                execdir = execdir.resolve()
                print("Launching job: {}".format(jobname))

                jobdata = {"jobname": jobname,
                        "execdir": execdir,
                        "nbjob": 1,
                        "machine": conf_dict.get('machine'),
                        "queue": conf_dict.get('queue'),
                        "command": launcher.command( {'xml':item[1].get('xml'), 'controller':controller, 'seed':seeds[i]} )
                        }
                launcher.execute(jobdata)
                # time.sleep(0.5) #is this necessary ?
    print('End.')


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--config', help='config file (toml)')
    parser.add_argument('-o', '--output', help='Output folder')
    args = parser.parse_args()
    main(args)
