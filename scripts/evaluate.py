#!/usr/bin/python3
import os
import sys
import subprocess as sp
import argparse
import re
import time
import toml
from pathlib import Path
from shutil import copyfile

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
        self.exe = launcher.get("exe")
        self.regex = re.compile(launcher.get("regex"))

    @staticmethod
    def get_launcher(launcher):
        if launcher.get("type") == "auto":
            return AutoLauncher(launcher)
        elif launcher.get("type") == "neat":
            return NeatLauncher(launcher)

    def command(self, args):
        raise Exception("command method not implemented.")

    def execute(self, jobdata):
        print("executing..")
        # print(jobdata)
        # stdout = sp.check_output('sed -e "s/i/i/"', input=JOB_SCRIPT.format(**jobdata), universal_newlines=True, shell=True, stderr=sp.STDOUT)
        stdout = sp.check_output(
            "qsub -v PATH",
            input=JOB_SCRIPT.format(**jobdata),
            universal_newlines=True,
            shell=True,
            stderr=sp.STDOUT,
        )
        print(stdout)

    def get_score(self, log):
        return self.regex.search(log)


class AutoLauncher(Launcher):
    def command(self, args):
        return "{} -s {} -c {} --fsm-config {}".format(
            self.exe, args.get("seed"), args.get("xml"), args.get("controller")
        )

    def extract_res(self, name, optimfolder, d):
        # sp.check_output(command, shell=True, stderr=sp.STDOUT).decode("utf-8")
        t = re.compile(r"{}-(\d\d)".format(name))
        m = re.compile(r"# Best configurations as commandlines.*\n\d+  (.*)")
        try:
            os.mkdir(d)
        except Exception as e:
            print(e)
        f2 = open(os.path.join(d, "{}-results.txt".format(name)), "w")
        for i in os.listdir(optimfolder):
            if t.match(i):
                print(i)
                # y = t.match(i)
                f = open("{}/{}/irace.stdout".format(optimfolder, i))
                g = f.read()  # .decode("utf-8")
                fi = m.search(g)
                print(fi.group(1))
                f2.write(fi.group(1))
                f2.write("\n")
                f.close()


class NeatLauncher(Launcher):
    def command(self, args):
        return "{} -s {} -c {} -g {}".format(
            self.exe, args.get("seed"), args.get("xml"), args.get("controller")
        )

    def extract_res(self, name, optimfolder, d):
        t = re.compile(r"{}-(\d+)".format(name))
        try:
            os.makedirs(os.path.join(d, "results-evo-{}".format(name)))
        except Exception as e:
            print(e)
        for j, i in enumerate(os.listdir(optimfolder)):
            y = t.match(i)
            if y:
                print(i)
                copyfile(
                    os.path.join(optimfolder, i, "gen", "gen_last_1_champ"),
                    os.path.join(
                        d, "results-evo-{}/gen_champ_{}_{}".format(name, y.group(1), j)
                    ),
                )


def slugify(text):
    return re.sub(r"[\W_]+", "-", text.lower())


def main(args):
    print("Using conf file: {}".format(args.config))
    conf_dict = toml.load(args.config)
    launchers = conf_dict.get("launchers")
    for item in conf_dict.get("experiments").items():
        if (
            item[1].get("launcher")
            and item[1].get("xml")
            and item[1].get("controllers")
            and item[1].get("mission")
            and item[1].get("options")
        ):
            controllers = item[1].get("controllers")
            if os.path.isdir(Path(controllers)):
                input_controllers = os.listdir(Path(controllers))
            elif os.path.isfile(Path(controllers)):
                with open(Path(controllers), "r") as input_file:
                    input_controllers = input_file.readlines()
            else:
                raise Exception("No input controllers {}".format(controllers))

            if not os.path.isdir(Path(args.output)):
                raise Exception("Execution folder does not exist.")
            execution_folder = Path(args.output)

            with open(Path(conf_dict.get("seeds")), "r") as seed_file:
                seeds = [int(seed) for seed in seed_file]

            launcher = Launcher.get_launcher(launchers.get(item[1].get("launcher")))
            for i, controller in enumerate(input_controllers):
                jobname = slugify(
                    "{}-{}-{}-{}".format(
                        item[1].get("launcher"),
                        item[1].get("mission"),
                        item[1].get("options"),
                        seeds[i],
                    )
                )
                execdir = execution_folder / jobname
                execdir.mkdir()
                execdir = execdir.resolve()
                print("Launching job: {}".format(jobname))

                jobdata = {
                    "jobname": jobname,
                    "execdir": execdir,
                    "nbjob": 1,
                    "machine": conf_dict.get("machine"),
                    "queue": conf_dict.get("queue"),
                    "command": launcher.command(
                        {
                            "xml": item[1].get("xml"),
                            "controller": controller,
                            "seed": seeds[i],
                        }
                    ),
                }
                launcher.execute(jobdata)
                # time.sleep(0.5) #is this necessary ?
    print("End.")


def extract(args):
    print("Using conf file: {}".format(args.config))
    conf_dict = toml.load(args.config)
    launchers = conf_dict.get("launchers")
    for item in conf_dict.get("experiments").items():
        if (
            item[1].get("opti_name")
            and item[1].get("opti_dir")
            and item[1].get("launchers")
        ):
            launcher = Launcher.get_launcher(launchers.get(item[1].get("launcher")))
            if not os.path.isdir(Path(args.output)):
                raise Exception("Execution folder does not exist.")
            output_folder = Path(args.output)
            launcher.extract_res(
                item[1].get("opti_name"), item[1].get("opti_dir"), output_folder
            )
        else:
            raise Exception(
                "Missing parameter in configuration: opti_name, opti_dir or launchers"
            )


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--config", help="config file (toml)")
    parser.add_argument("-o", "--output", help="Output folder")
    parser.add_argument(
        "-e",
        "--extract",
        action="store_true",
        help="First used to extract data from outputs of design",
    )
    args = parser.parse_args()

    if args.extract:
        extract(args)
    else:
        main(args)
