#!/usr/bin/python2

import argparse
import subprocess
import os
import re
import sys
import shutil

p = argparse.ArgumentParser(description='video generation based on images')
p.add_argument('-d', '--dir', nargs='+', help='input dirs', required=True)


CAMFILES = "CAM_CST37_TS_%06d.bmp"


def main(args):
    rungex = re.compile('run_(\d\d\d)')
    for d in args.dir:
        rundirs = os.listdir(d)
        dirname = os.path.basename(d)
        for run in rundirs:
            d2 = rungex.match(run)
            if d:
                path = os.path.join(os.path.abspath(d),d2.group(0),"images")
                videofile = "{}-{}.avi".format(dirname,d2.group(1))
                subprocess.check_call("avconv -r 12.0205 -i '{}/{}' -vcodec libx264 -threads 8 -preset medium -tune stillimage {}".format(path,CAMFILES,videofile), shell=True)
                try:
                    os.makedirs(os.path.join( "images-{}".format(dirname),d2.group(0) ))
                except Exception as e:
                    print(e)
                runimages = os.listdir( path )
                for image in runimages[::180]: ##take one images every 15sec (at 12fps)
                    shutil.copy( os.path.join(path, image), os.path.join("images-{}".format(dirname),d2.group(0)) )


if __name__ == '__main__':
    args = p.parse_args()
    main(args)
