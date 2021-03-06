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
p.add_argument('-r', '--repeat', help="number of repetitions per instance", type=int, default=1, required=False)
p.add_argument('-i', '--id', help="id of methods(to be apppened to score file name)", required=True)

CONF = {
        "Beacon Stop":
        (
            #auto
            ("/home/ken/depots/robots-thesis/Results/Gian/results2X/results15/beacstop2.0dev-results.txt", 'auto', 'beacstop2',
                "automodegianduja_beacon_stop.xml"),
            ("/home/ken/depots/robots-thesis/Results/Gian/results2X/results15/beacstop2.1dev-results.txt", 'auto2', 'beacstop21',
                "automodegianduja_beacon_stop.xml"),
            ("/home/ken/depots/robots-thesis/Results/Gian/results2X/results15/beacstop3.0dev-results.txt", 'auto', 'beacstop3',
                "automodegianduja_beacon_stop.xml"),
            ("/home/ken/depots/robots-thesis/Results/Gian/results2X/results15/beacstop3.1dev-results.txt", 'auto2', 'beacstop31',
                "automodegianduja_beacon_stop.xml"),
            #evo
            ("/home/ken/depots/robots-thesis/Results/Gian/results2X/results15/results-evo-beacstop", 'evo', 'beacstopevo',
                "automodegianduja_beacon_stop.xml"),
            ("/home/ken/depots/robots-thesis/Results/Gian/results2X/results15/results-evo-beacstop2x", 'evo', 'beacstopevo2X',
               "automodegianduja_beacon_stopX.xml"),
            ("/home/ken/depots/robots-thesis/Results/Gian/results2X/results15/results-evo-beacstop3", 'evo', 'beacstopevo3',
                "automodegianduja_beacon_stop3.xml"),
            ("/home/ken/depots/robots-thesis/Results/Gian/results2X/results15/results-evo-beacstop3x", 'evo', 'beacstopevo3X',
               "automodegianduja_beacon_stop3X.xml"),
            #PR
            #auto
            ("/home/ken/depots/robots-thesis/Results/Gian/results2X/results15/beacstop2.0dev-results.txt", 'auto', 'beacstop2',
                "automodegianduja_beacon_stopPR.xml"),
            # ("/home/ken/depots/robots-thesis/Results/Gian/results2X/results15/beacstop2.1dev-results.txt", 'auto2', 'beacstop21BIG',
            #     "automodegianduja_beacon_stopBIG.xml"),
            # ("/home/ken/depots/robots-thesis/Results/Gian/results2X/results15/beacstop2.1dev-results.txt", 'auto2', 'beacstop21BIG',
                # "automodegianduja_beacon_stopBIGPR.xml"),
            ("/home/ken/depots/robots-thesis/Results/Gian/results2X/results15/beacstop2.1dev-results.txt", 'auto2', 'beacstop21',
                "automodegianduja_beacon_stopPR.xml"),
            ("/home/ken/depots/robots-thesis/Results/Gian/results2X/results15/beacstop3.0dev-results.txt", 'auto', 'beacstop3',
                "automodegianduja_beacon_stopPR.xml"),
            ("/home/ken/depots/robots-thesis/Results/Gian/results2X/results15/beacstop3.1dev-results.txt", 'auto2', 'beacstop31',
                "automodegianduja_beacon_stopPR.xml"),
    }

NEATFOLDER = "/home/ken/depots/neat-argos3"
#NEAT1FOLDER = "/home/ken/depots/old_gian"
AUTOFOLDER = "/home/ken/depots/argos3-Automode"
AUTO21FOLDER = "/home/ken/depots/argos3-Automode21"
#AUTO1FOLDER = "/home/ken/depots/argos3-Automode1"

#METHODS = ( 'Gianduja2', 'Gianduja2E', 'Gianduja3', 'Gianduja3E', 'EvoCom2', 'EvoCom2X', 'EvoCom3', 'EvoCom3X',
#'Gianduja2PR', 'Gianduja2EPR', 'Gianduja3PR', 'Gianduja3EPR', 'EvoCom2PR', 'EvoCom2XPR', 'EvoCom3PR', 'EvoCom3XPR', )
#METHODS = ( 'Gianduja2E', 'Gianduja2EPR', 'EvoCom2', 'EvoCom2PR')

#SEEDS = [98128,78246,5081,51028,28832,37383,34385,7583,95415,16672,9221,14671,7550,96043,58134,94393,79820,19890,46885,52388,87754,47343,13478,17254,39786,12071,82478,51590,90271,21440,88504,10126,72952,57303,87190,74278,58122,69996,62778,66277,61464,43039,92123,77088,52577,70407,69179,82028,45716,9989,39975,45670,35842,85831,96278,80536,87372,99892,89604,83114,6497,92972,11535,92749,82858,15932,61397,78113,30010,48677,40027,55937,79284,37609,10327,42676,33507,84383,21087,12499,24034,88644,23820,71629,7732,19319,3365,16774,31355,7638,8528,36091,58938,66126,22108,33965,97046,48792,62804,68988,26587,54961,2954,47708,34028,36482,81391,99726,26518,72623,80215,89653,87266,10839,27026,5795,6481,648254,87124,11627,62506,51785,36911,6679,8832,564211,64049,9615,5320,259204,5515,8628,565757,72321,46009,16519,4686,43032,34280,84357,55124,93746,93670,85757,49975,28413,88216,95239,21483,32900,84008,57612,60900,77622,72184,63036,4377,67310,8329,19553,70157,97793,45059,87549,44650,56617,83729,17988,80308,74870,81425,73849,7612,74525,6082,5535,18892,54109,62956,70654,30093,59206,66078,57389,29920,41911,34996,32772,18813,15631,44994,67962,43963,62189,65015,20277,20892,94474,42929,87693]

SEEDS = ["98128", "5081", "7583", "51028", "37383", "95415", "78246", "16672", "28832", "34385"]


def evo(seed, genome, xml, neatfolder):
    binary = os.path.join(neatfolder,"bin/NEAT-launch")
    command =  "%s -c %s --seed %i -g %s" % (binary,xml,seed,genome)
    try:
        print("running %s" % command)
        pro = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
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
        pro = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
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
        pro = subprocess.run(command, shell=True ,stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
        #print("this is stdout : %s" % pro.stdout)
        #m = re.search("Score (\d+.\d+)", str(pro.stdout))
        c = re.search("Message=.*(blanc|noir)", str(pro.stdout))
        if c:
            print('color:')
            print(c.group(1))
        m = re.search("Score (\d*)", str(pro.stdout))
        #print(m.group(1))
        return m.group(1)
    except Exception as e:
        print(e)


def write_res_2(scores, task, id):
    print('opening score file')
    f = open('scores{}-{}.txt'.format(id,task,), 'a')
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

    for method in CONF[task]:
        print(method)
        if method[1] == 'evo1':
            xml = os.path.join(NEAT1FOLDER,'experiments',method[3])
            g = os.listdir(method[0])
            scoresevo = []
            i = 0
            for l in g:
                for rep in range(int(args.repeat)):
                    sc = evo1(SEEDS[i],os.path.join(method[0],l),xml, NEAT1FOLDER)
                    scoresevo.append(sc)
                    print(sc)
                    i += 1
            scores.append(scoresevo)

        elif method[1] == 'evo':
            xml = os.path.join(NEATFOLDER,'experiments',method[3])
            g = os.listdir(method[0])
            scoresevo = []
            i = 0
            for l in g:
                for rep in range(int(args.repeat)):
                    sc = evo(SEEDS[i],os.path.join(method[0],l),xml, NEATFOLDER)
                    scoresevo.append(sc)
                    print(sc)
                    i += 1
            scores.append(scoresevo)

        elif method[1] == "auto":
            xml = os.path.join(AUTOFOLDER,'experiments',method[3])
            f = open(method[0])
            scoresauto = []
            i = 0
            for l in f:
                for rep in range(int(args.repeat)):
                    sc = auto(SEEDS[i],l.strip(),xml, AUTOFOLDER)
                    scoresauto.append(sc)
                    print(sc)
                    i += 1
            f.close()
            scores.append(scoresauto)

        elif method[1] == "auto2":
            xml = os.path.join(AUTO21FOLDER,'experiments',method[3])
            f = open(method[0])
            scoresauto = []
            i = 0
            for l in f:
                for rep in range(int(args.repeat)):
                    sc = auto(SEEDS[i],l.strip(),xml, AUTO21FOLDER)
                    scoresauto.append(sc)
                    print(sc)
                    i += 1
            f.close()
            scores.append(scoresauto)

    write_res_2(scores, task, args.id)
    #run_R('scores-%s.txt' % task, task)


if __name__ == "__main__":
    print(CONF.keys())
    for item in CONF:
        print(item)
        main(item)
