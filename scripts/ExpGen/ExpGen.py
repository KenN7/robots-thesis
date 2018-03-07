#!/usr/bin/python3

## experiment for generator for neat, AutoMode and maybe more ?

import argparse
import subprocess
import os
import re
import shlex
import stat

import xml.etree.ElementTree as xml
from random import shuffle

p = argparse.ArgumentParser(description='prepare your experiment files and helping array sheet.')
p.add_argument('-s', '--seeds', help='the seed file', required=True)
p.add_argument('-x', '--xml', help='the xml file of the mission', required=True)
p.add_argument('-xx', '--xml2', help='the xml file for the path_planning with ITS', required=True)
p.add_argument('-n', '--number', help='number of experiments to run', required=True)
p.add_argument('-o', '--outputtable', help='the table output file summing up all the experiments', required=True)


class Experiment:
    def __init__(self, controller, xmlparam, exe):
        self.name = controller
        self.xmlparam = xmlparam
        self.executable = exe
        self.controllerslist = None

    def load_fsm(self, fsmfile):
        with open(fsmfile,'r') as f:
            self.controllerslist = f.read().splitlines()

    def load_gen(self, genfolder):
        self.controllerslist = os.listdir(genfolder)

def genXml(i, xmlfile, seed, controllers, output):
    e = xml.parse(xmlfile)
    argos = e.getroot()
    #set random seed in xml
    fr = argos.find('framework')
    exp = fr.find('experiment')
    exp.set('random_seed', str(seed))

    #set controllers
    c = argos.find('controllers')
    if len(c) != len(controllers):
        print(c)
        print(controllers)
        raise Exception('Number of controllers defined in XML file does not match controllers defined in this script.')

    for controller in controllers:
        #auto = c.find('epuck_nn_controller')
        try:
            con = c.find(controller.name)
            pa = con.find('params')
            pa.set(controller.xmlparam, controller.controllerslist[i])
                #pa.set('fsm-config', gen)
                #pa.set('genome_file', gen)
        except Exception as e:
            print(e)
            print('Could not find or problem with XML and controller', controller.name)
            raise

    e.write(output)
    return output


def genXml_path_pla(i, xmlfile, seed, output):
    e = xml.parse(xmlfile)
    argos = e.getroot()
    #set random seed in xml
    fr = argos.find('framework')
    exp = fr.find('experiment')
    exp.set('random_seed', str(seed))
    e.write(output)
    return output


if __name__ == "__main__":
    args = p.parse_args()
    xmlfile = args.xml
    xmlfile2 = args.xml2
    tablefile = args.outputtable

    ### define here all experiments to run and shuffle and load FSM or GEN files
    ###
    ###
    exps = []
    exps.append(Experiment('automode_gianduja', 'fsm-config', 'automode'))
    exps[0].load_fsm('/home/ken/depots/robots-thesis/scripts/test/temp/stop-results.txt')
    exps.append(Experiment('epuck_nn_controller', 'genome_file', 'epuck_nn'))
    exps[1].load_gen('/home/ken/depots/robots-thesis/scripts/test/temp/results-evo-stop227')
    exps.append(Experiment('automode_controller', 'fsm-config', 'automode'))
    exps[2].load_fsm('/home/ken/depots/robots-thesis/scripts/test/temp/stopnogian0102-results.txt')
    # exps.append(Experiment('automode_gianduja', 'fsm-config', 'automode'))
    # exps[0].load_fsm('/home/ken/depots/robots-thesis/scripts/test/temp/decision-results.txt')
    # exps.append(Experiment('epuck_nn_controller', 'genome_file', 'epuck_nn'))
    # exps[1].load_gen('/home/ken/depots/robots-thesis/scripts/test/temp/results-evo-dec227')
    # exps.append(Experiment('automode_controller', 'fsm-config', 'automode'))
    # exps[2].load_fsm('/home/ken/depots/robots-thesis/scripts/test/temp/desinogian0102-results.txt')
    #exps.append(Experiment('automode_gianduja', 'fsm-config', 'automode'))
    #exps[0].load_fsm('/home/ken/depots/robots-thesis/scripts/test/temp/aggreg-results.txt')
    #exps.append(Experiment('epuck_nn_controller', 'genome_file', 'epuck_nn'))
    #exps[1].load_gen('/home/ken/depots/robots-thesis/scripts/test/temp/results-evo-agg227')
    #exps.append(Experiment('automode_controller', 'fsm-config', 'automode'))
    #exps[2].load_fsm('/home/ken/depots/robots-thesis/scripts/test/temp/aggnogian0102-results.txt')
    ###
    ###
    with open(args.seeds, 'r') as f:
        seeds = f.read().splitlines()

    missionname = re.search("(\S+)(\.xml|\.argos)",os.path.basename(xmlfile)).group(1)
    print(missionname)

    #generate XML files and list all experiments to do
    try:
        os.mkdir("Robotfiles")
    except OSError:
        print("XMLFiles folder already exists, continuing..")

    try:
        os.mkdir("PCfiles")
    except OSError:
        print("PCfiles folder already exists, continuing..")

    experiments = []
    for i in range(int(args.number)):
        generatedxml = genXml(i, xmlfile, seeds[i], exps, os.path.join('Robotfiles',"%s_%s.xml" % (missionname,seeds[i])))
        gen_path_plaxml = genXml_path_pla(i, xmlfile2, seeds[i], os.path.join('PCfiles',"pathpla_%s_%s.xml" % (missionname,seeds[i])))
        for exp in exps:
            experiments.append((seeds[i],exp,generatedxml,gen_path_plaxml))

    #suffle all experiments
    shuffle(experiments)

    #generate table of shuffled experiments and starting script for robots
    #generate script file for lauching on robots and on PC for position
    f1 = open(tablefile, 'w')
    f1.write('| Num of exp | xml | seed | controller\n')
    f1.write('| ---- | ---- | ---- | ----\n')

    f2 = open(os.path.join('Robotfiles',"startE.sh"), 'w')
    f2.write("#!/bin/bash\n")

    f3 = open(os.path.join('PCfiles','startPathPla.sh'), 'w')
    f3.write("#!/bin/bash\n")

    for (i,(seed,exp,xml,pathxml)) in enumerate(experiments):
        f1.write("| %s | %s | %s | %s\n" % (i,xml,seed,exp.name))

        if i==0:
            f2.write('if [ "$1" == "0" ]; then ./%s -i %s -c %s\n' % (exp.executable,exp.name,os.path.basename(xml)))
            f3.write('if [ "$1" == "0" ]; then exec argos3 -c %s\n' % os.path.abspath(xml))
        else:
            f2.write('elif [ "$1" == "%i" ]; then ./%s -i %s -c %s\n' % (i,exp.executable,exp.name,os.path.basename(xml)))
            f3.write('elif [ "$1" == "%i" ]; then exec argos3 -c %s\n' % (i,os.path.abspath(pathxml)))
        #  ./%s -i %s -c %s
    f2.write('else echo "ERROR: Unknown expe number $1"\nfi')
    f3.write('else echo "ERROR: Unknown expe number $1"\nfi')
    f1.close()
    f2.close()
    f3.close()

    st_file = os.stat(os.path.join('Robotfiles',"startE.sh"))
    os.chmod(os.path.join('Robotfiles',"startE.sh"), st_file.st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)

    st_file = os.stat(os.path.join('PCfiles',"startPathPla.sh"))
    os.chmod(os.path.join('Robotfiles',"startPathPla.sh"), st_file.st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)
