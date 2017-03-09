
import argparse
import subprocess
import os
import re
import shlex
from mpi4py import MPI
from mpi4py.MPI import ANY_SOURCE
import statistics

p = argparse.ArgumentParser(description='runs a command multiple times in paralell using mpi :  mpirun -n 5 python looprunner.py -n 50 -c "COMMAND"')
p.add_argument('-c', '--command', help='the command to run', required=True)
p.add_argument('-n', '--nbruns', help='number of runs to do (max 100)', required=True)

SEEDS = [380968, 743177, 632232, 250754, 750471, 598927, 333897, 251738, 546483, 784880, 521015, 551313, 493518, 303317, 610661, 366227, 562388, 613984, 648791, 890135, 687202, 613436, 503604, 910664, 776270, 472033, 840270, 862703, 155988, 740271, 731764, 832524, 677191, 238062, 171257, 973593, 835648, 779231, 654204, 480391, 485520, 470411, 610365, 210071, 738896, 320922, 448045, 536203, 924663, 821665, 477301, 351450, 670725, 371096, 283370, 599440, 785988, 930041, 476407, 555191, 565081, 176706, 285496, 638927, 755443, 636342, 724515, 679508, 231024, 472011, 880336, 268158, 377113, 318753, 821850, 269153, 334119, 557035, 848259, 835392, 946899, 368748, 430480, 657169, 633922, 578862, 489143, 424892, 614003, 444886, 182887, 407901, 491641, 200860, 582865, 386150, 748602, 906394, 812650, 515604]


def main(seed):
    #chunks = int(int(args.nbruns)/(size-1))
    #interval = range(chunks*rank,(chunks*rank+chunks))
    try:
        command = shlex.split(args.command)
        command[3:3] = [ '--seed', str(seed) ]
        #print("running %s" % command)
        pro = subprocess.run(command, stdout=subprocess.PIPE)
        #print("this is stdout : %s" % pro.stdout)
        m = re.search("Score (\d+.\d+)", str(pro.stdout))
        #print(m.group(1))
        return m.group(1)
    except Exception as e:
        print(e)

if __name__ == "__main__":
    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()
    size = comm.Get_size()
    args = p.parse_args()

    print("hello from process %i" % rank)

    if rank == 0:
        res = []
        for i in range(int(args.nbruns)):
            recv_buffer = comm.recv()
            print(recv_buffer)
            res.append(float(recv_buffer))
        print('Mean : %f' % statistics.mean(res))
        print('StdDev : %f' % statistics.stdev(res))

    else:
        for i in range(int(args.nbruns)):
            if ( i%(size-1)+1 == rank ):
                r = main(SEEDS[i])
                comm.send(r, dest=0)
