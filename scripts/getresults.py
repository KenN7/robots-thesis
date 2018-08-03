
import argparse
import subprocess
import os
import re
import sys
import shlex
import shutil
from paramiko import SSHClient

p = argparse.ArgumentParser(description='getter, runner and grapher of results, options are choosed by editting the python file.')
p.add_argument('-d', '--dir', help="the directory where to save controllers", required=True)

CONF = {
    # "Decision":
    #     (
    #         ("/home/khasselmann/neat-argos3/optimization/expDEC", 'evo', 'desi0204'),
    #         ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'desi0204'),
    #         ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'desinogian0204')
    #     ),
    # "Aggregation":
    #     (
    #         ("/home/khasselmann/neat-argos3/optimization/expAGG", 'evo', 'agg0304' ),
    #         ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'agg0204'),
    #         ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'aggnogian0204')
    #     ),
    # "Stop":
    #     (
    #         ("/home/khasselmann/neat-argos3/optimization/expSTOP", 'evo', 'stop0304'),
    #         ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'stop0204'),
    #         ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'stopnogian0204')
    #     ),
    "Decision 2_0":
        (
            ("/home/khasselmann/argos3-AutoMoDe/optimization", 'auto', 'desi2_0'),
        )
    }

#METHODS = ('Evostick', 'AutoMoDe-Gianduja', 'AutoMoDe-Chocolate')

def extract_res_evo(name, remotefolder, sftp, d):
    t = re.compile('{}-(\d+)'.format(name))
    try:
        os.makedirs(os.path.join( d,'results-evo-{}'.format(name) ))
    except Exception as e:
        print(e)
    for i in sftp.listdir(remotefolder):
        y = t.match(i)
        if y:
            print(i)
            sftp.get(os.path.join(remotefolder,i,"gen","gen_last_1_champ"),\
            os.path.join( d,'results-evo-{}/gen_champ_{}'.format(name,y.group(1)) ))
    return os.path.abspath(os.path.join( d,'results-evo-{}'.format(name) ))


def extract_res_auto(name, remotefolder, sftp, d):
    t = re.compile('{}-200k-exp-(\d\d)'.format(name))
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
