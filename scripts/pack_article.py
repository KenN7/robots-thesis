#/usr/bin/python3

import re
import argparse
import subprocess
import shutil
import os
import logging
import tarfile
from pathlib import Path

p = argparse.ArgumentParser(description='Article packer for putting all your files in a single LaTeX file ready for submission.')
p.add_argument('-o', '--output', help="Output dir for submission.", required=True)
p.add_argument('-i', '--input', help="Main tex file of your submission.", required=True)
p.add_argument('-x', '--xfiles', help="Copy also .cls, .clo  and .sty files", action='store_true', required=False)

#
# TODO: - handle multiline pattern,
#       - add other cases like "includes",
#       - handle fig convert (for eps,ps,pdf)
#       - better regexes, for comments and inputs/includes
#       - handle Bibtex files, create bbl and include it
#       - compile and produce test pdf
#

def main():
    args = p.parse_args() #args.input and output

    input_path = Path(args.input)
    if input_path.is_file() == False:
        raise Exception("input is not a file.")
        exit(1)

    latex_path = input_path.absolute().parent
    os.chdir(latex_path)
    input_file = input_path.name

    try:
        os.makedirs(args.output)
    except Exception as e:
        print(e)
        exit(1)
    output_dir = args.output

    logging.warning('Processing file {} in {}'.format(input_file,output_dir))

    if args.xfiles:
        cur_files = os.listdir()
        for file in cur_files:
            name, suffix = os.path.splitext(file)
            if suffix == ".cls" or suffix == ".clo" or suffix == ".sty":
                shutil.copy(file,output_dir)

    #copy main tex file:
    main_file = shutil.copy(input_file,output_dir)

    main_file = remove_comments(main_file,output_dir)
    main_file = integrate_files(main_file,output_dir)
    main_file = handle_figs(main_file,output_dir)

    #remove temp file
    tmp_file = "{}.tmp".format(main_file)
    os.remove(tmp_file)

    make_tarfile(output_dir)



def make_tarfile(output_dir):
    files = os.listdir(output_dir)
    with tarfile.open(os.path.join(output_dir,"manuscript_archive.tar.gz"), "w:gz") as tar:
        for file in files:
            tar.add(file)


def handle_figs(input,output_dir):
    regex_figs = re.compile(r'\\includegraphics[^{]*\{\"*((?:(?!#).)*)\"*\}')
    tmp_file = "{}.tmp".format(input)
    with open(input,'r') as main_file:
        with open(tmp_file,'w') as tmp_out_file:
            for line in main_file:
                match_fig = re.search(regex_figs,line)
                if match_fig:
                    path_figure = find_fig_file(match_fig.group(1),output_dir)
                    line = line.replace(match_fig.group(1),path_figure)
                tmp_out_file.write(line)
    return shutil.copy(tmp_file,input)


def find_fig_file(file,output_dir):
    file_path = Path(file)
    if not file_path.is_file():
        logging.error("Could not find file {}".format(file_path))
        exit(1)
    shutil.copy(file_path,output_dir)

    return file_path.name


def integrate_files(input,output_dir):
    regex_inputs = re.compile(r'\\input\{\"*(.*?)\"*\}')
    tmp_file = "{}.tmp".format(input)
    with open(input,'r') as main_file:
        with open(tmp_file,'w') as tmp_out_file:
            for line in main_file:
                match_input = re.search(regex_inputs,line)
                if match_input:
                    text_to_add = find_tex_file(match_input.group(1))
                    line = line.replace(match_input.group(0),text_to_add)
                tmp_out_file.write(line)
    return shutil.copy(tmp_file,input)


def find_tex_file(file):
    if file.endswith(".tex"):
        file_path = Path(file)
    else:
        file_path = Path("{}.tex".format(file))

    if not file_path.is_file():
        logging.error("Could not find file {}".format(file_path))
        exit(1)
    with open(file_path,'r') as file:
        text = file.read()
    return text


def remove_comments(input,output_dir):
    regex_comments = re.compile(r'((?<!\\)(?:\\{2})*)%(.*)')
    tmp_file = "{}.tmp".format(input)
    with open(input,'r') as main_file:
        with open(tmp_file,'w') as tmp_out_file:
            for line in main_file:
                match_comment = re.search(regex_comments,line)
                if match_comment:
                    line = line.replace(match_comment.group(2),"")
                tmp_out_file.write(line)
    return shutil.copy(tmp_file,input)



if __name__ == '__main__':
    main()
