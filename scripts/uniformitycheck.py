#!/usr/bin/python

import statistics
import sys
import re
import collections

if __name__ == '__main__':
    f = open(sys.argv[1], 'r')
    reg = re.compile('--nstates (\d)')
    t = f.read()
    a = reg.findall(t)
    a = list(map(int, a))
    b = collections.Counter(a)

    print(b)
    print('%f %% of size 0' % (b[0]*100/len(a)) )
    print('%f %% of size 1' % (b[1]*100/len(a)) )
    print('%f %% of size 2' % (b[2]*100/len(a)) )
    print('%f %% of size 3' % (b[3]*100/len(a)) )
    print('%f %% of size 4' % (b[4]*100/len(a)) )
