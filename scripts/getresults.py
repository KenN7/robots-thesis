
import argparse
import subprocess
import os
import re
import sys
import shlex
import shutil
from paramiko import SSHClient

p = argparse.ArgumentParser(description='getter of results, options are choosed by editting the python file.')
p.add_argument('-d', '--dir', help="the directory where to save controllers", required=True)

CONF = {
    "DecisionNEO":
        (
            ("/home/khasselmann/neat-argos3/optimization/expDECCOMNEO3", 'evo', 'deccomneo'),
        ),
    "AggregationNEO":
        (
            ("/home/khasselmann/neat-argos3/optimization/expAGGCOMNEO2", 'evo', 'aggregcomneo' ),
        ),
    "StopNEO":
        (
            ("/home/khasselmann/neat-argos3/optimization/expSTOPCOMNEO2", 'evo', 'stopcomneo'),
        ),
    # "Decision1.x":
    #     (
    #         ("/home/khasselmann/old_neat/optimization/expDEC", 'evo', 'olddec1.21'),
    #         ("/home/khasselmann/temp", 'auto', 'dec1.3'),
    #         ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'dec1.2')
    #     ),
    # "Aggregation1.x":
    #     (
    #         ("/home/khasselmann/old_neat/optimization/expAGG", 'evo', 'oldneatagg1.21' ),
    #         ("/home/khasselmann/temp", 'auto', 'agg1.3'),
    #         ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'agg1.2')
    #     ),
    # "Stop1.x":
    #     (
    #         ("/home/khasselmann/old_neat/optimization/expSTOP", 'evo', 'stopold1.2[2-4]'),
    #         ("/home/khasselmann/temp", 'auto', 'stop1.3'),
    #         ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'stop1.2')
    #     ),
    #"BeacAgg": # bagg2.0d-new-exp-01  bagg3.0d-new-exp-01  bagg2.1d-new-exp-01 bagg3.1d-new-exp-01
    #    (

    #        ("/home/khasselmann/argos3-AutoMoDe21/optimization", 'auto', 'bagg6_6_2.1d-240-nlongRange'),
    #        # ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'beacagg3.0dev'),
    #        # ("/home/khasselmann/argos3-AutoMoDe21/optimization", 'auto', 'beacagg3.1dev'),
    #        # ("/home/khasselmann/neat-argos3/optimization/expBAG3", 'evo', 'beacagg3'),
    #        # ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'bagg3.0d-new'),
    #        # ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'bagg2.0d-new'),
    #        # ("/home/khasselmann/argos3-AutoMoDe21/optimization", 'auto', 'bagg2.1d-new'),
    #        # ("/home/khasselmann/argos3-AutoMoDe21/optimization", 'auto', 'bagg3.1d-new'),
    #        # ("/home/khasselmann/neat-argos3/optimization/expBAG2-2N", 'evo', 'beacagg2-new'),
    #        # ("/home/khasselmann/neat-argos3/optimization/expBAG3-2N", 'evo', 'beacagg3-new'),
    #        #("/home/khasselmann/neat-argos3/optimization/expBAG3X", 'evo', 'beacagg3x'),
    #        # ("/home/khasselmann/neat-argos3/optimization/expBAG2X", 'evo', 'beacagg2x'),
    #        # ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'beacagg2.0dev'),
    #        # ("/home/khasselmann/argos3-AutoMoDe21/optimization", 'auto', 'beacagg2.1dev'),
    #        # ("/home/khasselmann/neat-argos3/optimization/expBAG", 'evo', 'beacagg')
    #    ),
    #"BeacStop": #bstop2.0d-new-exp-03  bstop3.0d-new-exp-01 bstop2.1d-new-exp-01 bstop3.1d-new-exp-01
    #    (
    #        # ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'beacstop3.0dev'),
    #        # ("/home/khasselmann/argos3-AutoMoDe21/optimization", 'auto', 'beacstop3.1dev'),
    #        # ("/home/khasselmann/neat-argos3/optimization/expBSTOP3", 'evo', 'beacstop3'),
    #        # ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'bstop2.0d-new'),
    #        # ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'bstop3.0d-new'),
    #        # ("/home/khasselmann/argos3-AutoMoDe21/optimization", 'auto', 'bstop2.1d-new'),
    #        # ("/home/khasselmann/argos3-AutoMoDe21/optimization", 'auto', 'bstop3.1d-new'),
    #        # ("/home/khasselmann/neat-argos3/optimization/expBSTOP2-2N", 'evo', 'beacstop2-new'),
    #        # ("/home/khasselmann/neat-argos3/optimization/expBSTOP3-2N", 'evo', 'beacstop3-new'),
    #        #("/home/khasselmann/neat-argos3/optimization/expBSTOP3X", 'evo', 'beacstop3x'),
    #        #("/home/khasselmann/neat-argos3/optimization/expBSTOP2X", 'evo', 'beacstop2x'),
    #        # ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'beacstop2.0dev'),
    #        # ("/home/khasselmann/argos3-AutoMoDe21/optimization", 'auto', 'beacstop2.1dev'),
    #        # ("/home/khasselmann/neat-argos3/optimization/expBSTOP", 'evo', 'beacstop')
    #    ),
    #"BeacDec": # bdec2.0d-new-exp-03  bdec3.0d-new-exp-01 bdec2.1d-new-exp-01 bdec3.1d-new-exp-01
    #    (
    #        # ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'beacdec3.0dev'),
    #        # ("/home/khasselmann/argos3-AutoMoDe21/optimization", 'auto', 'beacdec3.1dev'),
    #        #("/home/khasselmann/neat-argos3/optimization/expBDEC3X", 'evo', 'beacdec3x'),
    #        # ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'bdec2.0d-new'),
    #        # ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'bdec3.0d-new'),
    #        # ("/home/khasselmann/argos3-AutoMoDe21/optimization", 'auto', 'bdec2.1d-new'),
    #        # ("/home/khasselmann/argos3-AutoMoDe21/optimization", 'auto', 'bdec3.1d-new'),
    #        # ("/home/khasselmann/neat-argos3/optimization/expBDEC2-2N", 'evo', 'beacdec2-new'),
    #        # ("/home/khasselmann/neat-argos3/optimization/expBDEC3-2N", 'evo', 'beacdec3-new'),
    #        #("/home/khasselmann/neat-argos3/optimization/expBDEC2X", 'evo', 'beacdec2x'),
    #        # ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'beacdec2.0dev'),
    #        # ("/home/khasselmann/argos3-AutoMoDe21/optimization", 'auto', 'beacdec2.1dev2'),
    #        # ("/home/khasselmann/neat-argos3/optimization/expBDEC", 'evo', 'beacdec')
    #    )
    # "xor2":
    #     (
    #         ("/home/khasselmann/AutoMoDe-private/optimization", "auto", "xor2_50kdep"),
    #         ("/home/khasselmann/AutoMoDe-private/optimization", "auto", "xor2_50kNOdep") 
    #     ),
    # "foraging":
    #     (
    #         ("/home/khasselmann/AutoMoDe-private/optimization", "auto", "foraging_50kdep"),
    #         ("/home/khasselmann/AutoMoDe-private/optimization", "auto", "foraging_50kNOdep")
    #     )
    # "shelterblack":
    #     (
    #         ("/home/khasselmann/AutoMoDe-private/optimization", "auto", "shelterblack"),
    #     )
    }

#METHODS = ('Evostick', 'AutoMoDe-Gianduja', 'AutoMoDe-Chocolate')
# METHODS = ('AutoMoDe-Chocolate-dep', 'AutoMoDe-Chocolate-NOdep')

METHODS = ('Evostick-2')

def extract_res_evo(name, remotefolder, sftp, d):
    t = re.compile('{}-(\d+)'.format(name))
    try:
        os.makedirs(os.path.join( d,'results-evo-{}'.format(name) ))
    except Exception as e:
        print(e)
    for j,i in enumerate(sftp.listdir(remotefolder)):
        y = t.match(i)
        if y:
            print(i)
            sftp.get(os.path.join(remotefolder,i,"gen","gen_last_1_champ"),\
            os.path.join( d,'results-evo-{}/gen_champ_{}_{}'.format(name,y.group(1),j ) ))
    return os.path.abspath(os.path.join( d,'results-evo-{}'.format(name) ))


def extract_res_auto(name, remotefolder, sftp, d):
    t = re.compile('{}-(\d\d)'.format(name))
    m = re.compile(r"# Best configurations as commandlines \(first number is the configuration ID\)\n\d*  (.*)")
    try:
        os.mkdir(d)
    except Exception as e:
        print(e)
    f2 = open(os.path.join( d,'{}-results.txt'.format(name) ),'w')
    for i in sftp.listdir(remotefolder):
        if t.match(i):
            print(i)
            y = t.match(i)
            f = sftp.open("{}/{}/irace.stdout".format(remotefolder,i))
            g = f.read().decode()
            fi = m.search(g)
            print(fi.group(1))
            f2.write(fi.group(1))
            f2.write('\n')
            f.close()
            #print(y.group(1))
    f2.close()
    return os.path.abspath(os.path.join( d,'{}-results.txt'.format(name) ))


def main(task):
    # expfile, genfolder, autopfsm
    #evo
    args = p.parse_args()

    for method in CONF[task]:
        client = SSHClient()
        client.load_system_host_keys()
        client.connect('majorana.ulb.ac.be', username='khasselmann')
        print('connected..')
        if method[1] == 'evo':
            sftp = client.open_sftp()
            direxp = extract_res_evo(method[2],method[0], sftp, args.dir)

        elif method[1] == "auto":
            print('open stfp..')
            sftp = client.open_sftp()
            #os.mkdir
            autopfsm = extract_res_auto(method[2],method[0], sftp, args.dir)
        client.close()

if __name__ == "__main__":
    for item in CONF:
        print(item)
        main(item)
