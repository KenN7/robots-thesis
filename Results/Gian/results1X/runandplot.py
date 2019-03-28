#!/usr/bin/python3
import argparse
import subprocess
import os
import re
import sys
import shlex
import shutil

p = argparse.ArgumentParser(description='runner and grapher of results, options are choosed by editting the python file.')
p.add_argument('-n', '--numberexp', help="number of tests to conduct (if not present test all available)", required=False)

CONF = {
    "Stop1X":
        (
            #"automodegianduja_stop.xml",
            #("/home/ken/depots/robots-thesis/scripts/results1X/results-evo-stopold1.2[2-4]", 'evo', 'stop1.2'),
            #("/home/ken/depots/robots-thesis/scripts/results1X/stop1.1-results.txt", 'auto', 'stop1.1E'),
            #("/home/ken/depots/robots-thesis/scripts/results1X/stop1.2-results.txt", 'auto', 'stop1.2EX'),
            #("/home/ken/depots/robots-thesis/scripts/results1X/stop1.3-results.txt", 'auto13', 'stop1.3X'),
            #("/home/ken/depots/robots-thesis/scripts/results1X/conf/results-evo-stop1304", 'evo1', 'stop1evo' ),
            #("/home/ken/depots/robots-thesis/scripts/results1X/conf/stop1304-results.txt", 'auto1', 'stop1'),
            #("/home/ken/depots/robots-thesis/scripts/results1X/conf/stopnogian1304-results.txt", 'auto1', 'stop1C')
        ),
    "Aggregation1X":
        (
            #"automodegianduja_aggregation.xml",
            #("/home/ken/depots/robots-thesis/scripts/results1X/results-evo-oldneatagg1.21", 'evo', 'agg1.2' ),
            #("/home/ken/depots/robots-thesis/scripts/results1X/agg1.1-results.txt", 'auto', 'agg1.1E'),
            #("/home/ken/depots/robots-thesis/scripts/results1X/agg1.2-results.txt", 'auto', 'agg1.2EX'),
            #("/home/ken/depots/robots-thesis/scripts/results1X/agg1.3-results.txt", 'auto13', 'agg1.3X'),
            #("/home/ken/depots/robots-thesis/scripts/results1X/conf/results-evo-agg1304", 'evo1', 'agg1evo' ),
            #("/home/ken/depots/robots-thesis/scripts/results1X/conf/aggreg1304-results.txt", 'auto1', 'agg1'),
            #("/home/ken/depots/robots-thesis/scripts/results1X/conf/aggnogian1304-results.txt", 'auto1', 'agg1C')
        ),
    "Decision1X":
        (
            "automodegianduja_decision.xml",
            #("/home/ken/depots/robots-thesis/scripts/results1X/results-evo-olddec1.21", 'evo', 'dec1.2' ),
            #("/home/ken/depots/robots-thesis/scripts/results1X/dec1.1-results.txt", 'auto', 'dec1.1E'),
            #("/home/ken/depots/robots-thesis/scripts/results1X/dec1.2-results.txt", 'auto', 'dec1.2EX'),
            ("/home/ken/depots/robots-thesis/scripts/results1X/dec1.3-results.txt", 'auto13', 'dec1.3X'),
            #("/home/ken/depots/robots-thesis/scripts/results1X/conf/results-evo-dec1304", 'evo1', 'dec1evo' ),
            #("/home/ken/depots/robots-thesis/scripts/results1X/conf/desi1304-results.txt", 'auto1', 'dec1'),
            #("/home/ken/depots/robots-thesis/scripts/results1X/conf/desinogian1304-results.txt", 'auto1', 'dec1C'),

        ),
    # "Aggregation 2 Spots":
    #     ( "automodegianduja_aggregation_2spots.xml",
    #     "/home/ken/depots/neat-argos3/optimization/expAGG2/results-evo-agg298",
    #     "/home/ken/depots/argos3-Automode/optimization/aggreg2spotsng-200k-exp-results.txt" )
    }

NEATFOLDER = "/home/ken/depots/neat-argos3"
NEAT1FOLDER = "/home/ken/depots/old_gian"
AUTOFOLDER = "/home/ken/depots/argos3-Automode1.1"
AUTO1FOLDER = "/home/ken/depots/argos3-Automode1"
AUTO13FOLDER = "/home/ken/depots/argos3-Automode13"

#METHODS = ('EvoComX', 'GiandujaE', 'GiandujaEX', 'EvoCom', 'Gianduja', 'Chocolate')
#METHODS = ('GiandujaX',)

SEEDS = [98128,78246,5081,51028,28832,37383,34385,96043,95415,9221,16672,14671,79820,7583,58134,94393,7548,19890,46885,52388,87754,47343,13478,17254,39786,12071,82478,51590,90271,21440,88504,10126,72952,57303,87190,74278,58122,69996,62778,66277,61464,43039,92123,77088,52577,70407,69179,82028,45716,9989,39975,45670,35842,85831,96278,80536,87372,99892,89604,83114,6497,92972,11535,92749,82858,15932,61397,78113,30010,48677,40027,55937,79284,37609,10327,42676,33507,84383,21087,12499,24034,88644,23820,71629,7732,19319,3365,16774,31355,7638,8528,36091,58938,66126,22108,33965,97046,48792,62804,68988,26587,54961,2954,47708,34028,36482,81391,99726,26518,72623,80215,89653,87266,10839,27026,5795,6481,648254,87124,11627,62506,51785,36911,6679,8832,564211,64049,9615,5320,259204,5515,8628,565757,72321,46009,16519,4686,43032,34280,84357,55124,93746,93670,85757,49975,28413,88216,95239,21483,32900,84008,57612,60900,77622,72184,63036,4377,67310,8329,19553,70157,97793,45059,87549,44650,56617,83729,17988,80308,74870,81425,73849,7612,74525,6082,5535,18892,54109,62956,70654,30093,59206,66078,57389,29920,41911,34996,32772,18813,15631,44994,67962,43963,62189,65015,20277,20892,94474,42929,87693]


def evo(seed, genome, xml, neatfolder):
    binary = os.path.join(neatfolder,"bin/NEAT-launch")
    command =  "%s -c %s --seed %i -g %s" % (binary,xml,seed,genome)
    try:
        print("running %s" % command)
        pro = subprocess.run(command, shell=True, stdout=subprocess.PIPE)
        #print("this is stdout : %s" % pro.stdout)
        #m = re.search("Score (\d+.\d+)", str(pro.stdout))
        m = re.search("Score (\d*)", str(pro.stdout))
        #print(m.group(1))
        return m.group(1)
    except Exception as e:
        print(e)

def evo1(seed, genome, xml, neatfolder):
    binary = os.path.join(neatfolder,"bin/evostick_launch")
    command =  "%s -c %s --seed %i -g %s" % (binary,xml,seed,genome)
    try:
        print("running %s" % command)
        pro = subprocess.run(command, shell=True, stdout=subprocess.PIPE)
        #print("this is stdout : %s" % pro.stdout)
        #m = re.search("Score (\d+.\d+)", str(pro.stdout))
        m = re.search("Score (\d*)", str(pro.stdout))
        #print(m.group(1))
        return m.group(1)
    except Exception as e:
        print(e)


def auto(seed, statem, xml, autofolder):
    binary = os.path.join(autofolder,"bin/automode_main")
    command = "%s -c %s --seed %i --fsm-config %s" % (binary,xml,seed,statem)
    try:
        print("running %s" % command)
        pro = subprocess.run(command, shell=True ,stdout=subprocess.PIPE)
        #print("this is stdout : %s" % pro.stdout)
        #m = re.search("Score (\d+.\d+)", str(pro.stdout))
        c = re.search("(CCBLACK|CCWHITE)", str(pro.stdout))
        if c:
            print('color:')
            print(c.group(1))
        m = re.search("Score (\d*)", str(pro.stdout))
        #print(m.group(1))
        return m.group(1)
    except Exception as e:
        print(e)


def write_res(scores, task):
    print('opening score file')
    f = open('scores-%s.txt' % task, 'w')
    f.write('"res" "alg" "task"\n')
    i = 0
    for j,method in enumerate(scores):
        for res in method:
            f.write('"%i" "%s" "%s" "%s"\n' % (i,res,METHODS[j],task))
            i+=1
    print('finished writing score file..')
    f.close()


def write_res_2(scores, task):
    print('opening score file')
    f = open('scores-%s.txt' % task, 'w')
    f.write('"score","seed","alg","task","real"\n')
    #i = 0
    for j,method in enumerate(scores):
        for k,res in enumerate(method):
            f.write( '{},{},"{}","{}","simulation"\n'.format(res,SEEDS[k],METHODS[j],task) )
            #i+=1
    print('finished writing score file..')
    f.close()


def run_R(filen, title):
    c = "Rscript /home/ken/depots/robots-thesis/results/boxplots.r '%s' '%s'" % (filen, title)
    c = shlex.split(c)
    print('launching R..')
    print(c)
    pro = subprocess.run(c, stdout=subprocess.PIPE)


def main(task):
    # expfile, genfolder, autopfsm
    #evo
    args = p.parse_args()

    scores = []

    expfile = CONF[task][0]
    for method in CONF[task][1:]:
        if method[1] == 'evo1':
            xml = os.path.join(NEAT1FOLDER,'experiments',expfile)
            g = os.listdir(method[0])
            scoresevo = []
            for i,l in enumerate(g):
                sc = evo1(SEEDS[i],os.path.join(method[0],l),xml, NEAT1FOLDER)
                scoresevo.append(sc)
                print(sc)
            scores.append(scoresevo)

        elif method[1] == 'evo':
            xml = os.path.join(NEATFOLDER,'experiments',expfile)
            g = os.listdir(method[0])
            scoresevo = []
            for i,l in enumerate(g):
                sc = evo(SEEDS[i],os.path.join(method[0],l),xml, NEATFOLDER)
                scoresevo.append(sc)
                print(sc)
            scores.append(scoresevo)

        elif method[1] == "auto":
            xml = os.path.join(AUTOFOLDER,'experiments',expfile)
            f = open(method[0])
            scoresauto = []
            for i,l in enumerate(f):
                sc = auto(SEEDS[i],l.strip(),xml, AUTOFOLDER)
                scoresauto.append(sc)
                print(sc)
            f.close()
            scores.append(scoresauto)

        elif method[1] == "auto13":
            xml = os.path.join(AUTO13FOLDER,'experiments',expfile)
            f = open(method[0])
            scoresauto = []
            for i,l in enumerate(f):
                sc = auto(SEEDS[i],l.strip(),xml, AUTO13FOLDER)
                scoresauto.append(sc)
                print(sc)
            f.close()
            scores.append(scoresauto)


    write_res_2(scores, task)
    #run_R('scores-%s.txt' % task, task)


if __name__ == "__main__":
    for item in CONF:
        print(item)
        main(item)
