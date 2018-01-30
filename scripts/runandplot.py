
import argparse
import subprocess
import os
import re
import sys
import shlex

# EXPFILE = "automodegianduja_aggregation.xml"
# EXPFILE = "automodegianduja_decision.xml"
# EXPFILE = "automodegianduja_stop.xml"
#
# GENFOLDER = "/home/ken/depots/neat-argos3/optimization/expAGG/results-evo-agg227"
# GENFOLDER = "/home/ken/depots/neat-argos3/optimization/expDEC/results-evo-dec227"
# GENFOLDER = "/home/ken/depots/neat-argos3/optimization/expSTOP/results-evo-stop227"
#
# AUTOPFSM = "/home/ken/depots/argos3-Automode/optimization/aggreg-200k-0208exp-results.txt"
# AUTOPFSM = "/home/ken/depots/argos3-Automode/optimization/decision-results.txt"
# AUTOPFSM = "/home/ken/depots/argos3-Automode/optimization/stop-results.txt"
#
# TASK = "aggreg"
# TASK = "decision"
# TASK = "stop"

CONF = {
    "Aggregation":
        (
            "automodegianduja_aggregation.xml", ("/home/khasselmann/neat-argos3/optimization/expAGG", 'evo', 'agg227' ),
            ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'aggreg')
            ("/home/ken/depots/argos3-Automode/optimization/aggreg-200k-0208exp-results.txt", 'auto', 'stopnogian1801')
        ),
    "Decision making":
        (
            "automodegianduja_decision.xml",
            ("/home/khasselmann/neat-argos3/optimization/expDEC", 'evo', 'dec227'),
            ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'decision')
            ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'desinogian1801')
        ),
    "Stop":
        (
            "automodegianduja_stop.xml",
            ("/home/khasselmann/neat-argos3/optimization/expSTOP", 'evo', 'stop227'),
            ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'stop')
            ("/home/ken/depots/argos3-Automode/optimization/stop-results.txt", 'auto', 'stopREALnogian1801')
        ),
    # "Aggregation 2 Spots":
    #     ( "automodegianduja_aggregation_2spots.xml",
    #     "/home/ken/depots/neat-argos3/optimization/expAGG2/results-evo-agg298",
    #     "/home/ken/depots/argos3-Automode/optimization/aggreg2spotsng-200k-exp-results.txt" )
    }

NEATFOLDER = "/home/ken/depots/neat-argos3"
AUTOFOLDER = "/home/ken/depots/argos3-Automode"

METHODS = ('Evostick', 'AutoMoDe-Gianduja', 'AutoMoDe-Chocolate')

SEEDS = [77622,72184,63036,4377,67310,8329,19553,70157,97793,45059,87549,44650,56617,83729,17988,80308,74870,81425,73849,7612,74525,6082,5535,18892,54109,62956,70654,30093,59206,66078,57389,29920,41911,34996,32772,18813,15631,44994,67962,43963,62189,65015,20277,20892,94474,42929,87693,98128,78246,5081,51028,28832,37383,34385,96043,95415,16672,9221,14671,79820,7583,58134,64049,7548,19890,46885,52388,87754,47343,46009,17254,39786,12071,82478,51590,90271,21440,88504,10126,72952,57303,87190,74278,58122,69996,62778,66277,61464,43039,92123,77088,52577,70407,69179,82028,45716,9989,39975,45670,35842,85831,96278,80536,87372,99892,89604,83114,6497,92972,11535,92749,82858,15932,61397,78113,30010,48677,40027,55937,79284,37609,10327,42676,33507,84383,21087,12499,24034,88644,23820,71629,7732,19319,3365,16774,31355,7638,8528,36091,58938,66126,22108,33965,97046,48792,62804,68988,26587,54961,2954,47708,34028,36482,81391,99726,26518,72623,80215,89653,87266,10839,27026,5795,6481,648254,87124,11627,62506,51785,36911,6679,8832,564211,94393,9615,5320,259204,5515,8628,565757,72321,13478,16519,4686,43032,34280,84357,55124,93746,93670,85757,49975,28413,88216,95239,21483,32900,84008,57612,60900]


def evo(seed, genome, xml):
    binary = os.path.join(NEATFOLDER,"bin/evostick_launch")
    command =  "%s -c %s --seed %i -g %s" % (binary,xml,seed,genome)
    try:
        command = shlex.split(command)
        #command[3:3] = [ '--seed', str(seed) ]
        print("running %s" % command)
        pro = subprocess.run(command, stdout=subprocess.PIPE)
        #print("this is stdout : %s" % pro.stdout)
        m = re.search("Score (\d+.\d+)", str(pro.stdout))
        #print(m.group(1))
        return m.group(1)
    except Exception as e:
        print(e)


def auto(seed, statem, xml):
    binary = os.path.join(AUTOFOLDER,"bin/automode_main")
    command = "%s -c %s --seed %i --fsm-config %s" % (binary,xml,seed,statem)
    try:
        command = shlex.split(command)
        #command[3:3] = [ '--seed', str(seed) ]
        print("running %s" % command)
        pro = subprocess.run(command, stdout=subprocess.PIPE)
        #print("this is stdout : %s" % pro.stdout)
        m = re.search("Score (\d+.\d+)", str(pro.stdout))
        #print(m.group(1))
        return m.group(1)
    except Exception as e:
        print(e)


def write_res(scores, task):
    print('opening score file')
    f = open('scores-%s.txt' % task, 'w')
    f.write('"res" "alg" "task"\n')
    i = 0
    for method in scores:
        for i,res in enumerate(method):
            f.write('"%i" "%s" "%s" "%s"\n' % (i,res,METHODS[i],task))
            i+=1
    print('finished writing score file..')


def run_R(filen, title):
    c = "Rscript /home/ken/depots/robots-thesis/results/boxplots.r '%s' '%s'" % (filen, title)
    c = shlex.split(c)
    print('launching R..')
    print(c)
    pro = subprocess.run(c, stdout=subprocess.PIPE)


def extract_res_evo(name, folder):
    t = re.compile('%s-(\d+)' % name)
    os.makedirs('temp/results-evo-%s' % name)
    for i in os.listdir(folder):
        if t.match(i):
            y = t.match(i)
            print(i)
            shutil.copyfile( i+"/gen/gen_last_1_champ",'temp/results-evo-%s/gen_champ_%s' % (sys.argv[1],y.group(1)) )
    return os.path.abspath('temp/results-evo-%s' % name)



def extract_res_auto(name, folder):
    t = re.compile('%s-200k-exp-(\d\d)' % name)
    m = re.compile(r"# Best configurations as commandlines \(first number is the configuration ID\)\n\d*  (.*)")

    os.mkdir('temp')
    f2 = open('temp/%s-results.txt' % name,'w')
    for i in os.listdir(folder):
        if t.match(i):
            print(i)
            y = t.match(i)
            f = open("%s/irace.stdout" % i)
            g = f.read()
            fi = m.search(g)
            print(fi.group(1))
            f2.write(fi.group(1))
            f2.write('\n')
            f.close()
            #print(y.group(1))
    f2.close()
    return os.path.abspath('temp/%s-results.txt' % name)


def main(task):
    # expfile, genfolder, autopfsm
    #evo
    #args = p.parse_args()

    #scp:
    #make dir temp


    scores = []

    expfile = CONF[task][0]
    for method in CONF[task][1:]:
        if method[1] == 'evo':

            scpcom = "scp -r khasselmann@majorana.ulb.ac.be:%s temp/" % method[0]
            command = shlex.split(command)
            print("running %s" % command)
            pro = subprocess.run(command, stdout=subprocess.PIPE)
            #os.mkdir
            direxp = extract_res_evo(method[2],os.path.join('temp',os.path.basename(method[0])))

            xml = os.path.join(NEATFOLDER,'experiments',expfile)
            g = os.listdir(direxp)
            scoresevo = []
            for i,l in enumerate(g):
                sc = evo(SEEDS[i],os.path.join(direxp,l),xml)
                scoresevo.append(sc)
                print(sc)
            scores.append(scoresevo)

        else if method[1] == "auto":

            scpcom = """rsync -rav -e ssh --include='*.stdout' khasselmann@majorana.ulb.ac.be:%s temp/""" % method[0]
            command = shlex.split(command)
            print("running %s" % command)
            pro = subprocess.run(command, stdout=subprocess.PIPE)
            print(pro.stdout)
            #os.mkdir
            autopfsm = extract_res_auto(method[2],os.path.join('temp',os.path.basename(method[0])))

            xml = os.path.join(AUTOFOLDER,'experiments',expfile)
            f = open(autopfsm)
            scoresauto = []
            for i,l in enumerate(f):
                sc = auto(SEEDS[i],l.strip(),xml)
                scoresauto.append(sc)
                print(sc)
            f.close()
            scores.append(scoresauto)

    # xml = os.path.join(NEATFOLDER,'experiments',expfile)
    # g = os.listdir(genfolder)
    # scoreevo = []
    # for i,l in enumerate(g):
    #     sc = evo(SEEDS[i],os.path.join(genfolder,l),xml)
    #     scoreevo.append(sc)
    #     print(sc)
    #
    # #auto
    # xml = os.path.join(AUTOFOLDER,'experiments',expfile)
    # f = open(autopfsm)
    # scoreauto = []
    # for i,l in enumerate(f):
    #     sc = auto(SEEDS[i],l.strip(),xml)
    #     scoreauto.append(sc)
    #     print(sc)

    write_res(scores, task)
    run_R('scores-%s.txt' % task, task)


if __name__ == "__main__":
    for item in CONF:
        print(item)
        main(item)
