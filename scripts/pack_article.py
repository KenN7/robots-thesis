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
p.add_argument('-b', '--bbl', help="Copy content of bbl file in the file, replacing the bibliography call", action='store_true', required=False)

logging.getLogger().setLevel(logging.INFO)
#
#
# TODO: - add other cases like "includes" (done not tested)
#       - handle fig convert (for eps,ps,pdf)
#       - even better regexes
#       - compile and produce test pdf
#

LIST_HANDLES_FILE = ("includegraphics", "bibliography")
LIST_HANDLES_INPUT = ("input",)
# If you use any special commands with paths as arguments,
# list them in LIST_HANDLES_FILE or INPUT :
# - LIST_HANDLES_FILE if the command contains a path to copy to the root folder
# - LIST_HANDLES_INPUT for text inputs that must be directly integrated in the final tex

# The regex for all commands (to use with .format)
CMD_REGEX = r'\\{}\s*(?:\[+[^{{]+\]+|)\s*\{{\s*\"*((?:(?!#).)*?)\"*\s*\}}'


def main():
    args = p.parse_args() #args.input and output

    input_path = Path(args.input)
    if input_path.is_file() == False:
        raise Exception("input is not a file.")
        exit(1)

    latex_path = input_path.absolute().parent
    input_file_path = input_path.absolute()
    input_name = input_path.name

    try:
        os.makedirs(args.output)
    except Exception as e:
        print(e)
        exit(1)
    output_dir = Path(args.output)

    logging.warning('Processing file {} in {}'.format(input_name,output_dir))

    if args.xfiles:
        cur_files = os.listdir(latex_path)
        for file in cur_files:
            name, suffix = os.path.splitext(file)
            if suffix == ".cls" or suffix == ".clo" or suffix == ".sty" or suffix == ".bst":
                shutil.copy(os.path.join(latex_path,file),output_dir)


    main_file_path = os.path.join(output_dir,input_name)

    #open main tex file:
    main_content = None
    with open(input_file_path,'r') as file:
        main_content = file.read()

    logging.info('Removing comments..')
    main_content = remove_comments(main_content)
    logging.info('Integrate texts..')
    main_content = integrate_text(main_content,latex_path)
    logging.info('Changing paths and copying files..')
    main_content = change_paths(main_content,latex_path,output_dir)

    if args.bbl:
        #special process for bibliography if we want to integrate bbl in file
        logging.info('Integrating bbl file..')
        main_content = integrate_bbl(main_content,latex_path,input_name)

    logging.info('Wrtiting main tex file..')
    #write output file:
    with open(main_file_path,'w') as file:
        file.write(main_content)

    #processing finished go into dir
    os.chdir(output_dir)
    logging.info('Making tarball..')
    make_tarfile()



def make_tarfile():
    files = os.listdir()
    with tarfile.open("manuscript_archive.tar.gz", "w:gz") as tar:
        for file in files:
            tar.add(file)


def change_paths(input,latex_path,output_dir):
    def repl(match):
        #maybe there a list is the match?
        list_files = match.group(1).split(",")
        list_new_files = []
        for file in list_files:
            file_found = find_file(file,latex_path)
            new_path = shutil.copy(file_found,output_dir)
            file_path = Path(new_path)
            list_new_files.append(file_path.name)
        start = match.span(1)[0] - match.start()
        end = match.span(1)[1] - match.start()
        return match.group(0)[:start] + ",".join(list_new_files) + match.group(0)[end:]

    for handle in LIST_HANDLES_FILE:
        regex = re.compile(CMD_REGEX.format(handle))
        # old: r'\\{}[^{{]*\{{\"*((?:(?!#).)*?)\"*\}}'
        # normal : \\\\{}[^{]*\\{\\"*((?:(?!#).)*?)\\"*\\}
        input = re.sub(regex,repl,input)
    return input


def find_file(filename,latex_path):
    file_path = Path(os.path.join(latex_path,filename))
    if not file_path.is_file():
        list_files_dir = os.listdir(file_path.parent)
        try:
            file_found = next(f for f in list_files_dir if file_path.name in f)
        except StopIteration:
            logging.error("Could not find file {}".format(file_path))
            exit(1)
        file_path = Path(os.path.join(latex_path,file_path.parent,file_found))
        if not file_path.is_file():
            logging.error("Could not find file {}".format(file_path))
            exit(1)
    return file_path


def integrate_text(input,latex_path):
    def repl(match):
        file_found = find_file(match.group(1),latex_path)
        with open(file_found) as found_file:
            text_file_found  = found_file.read()
            #remove comments from integrated text
            text_file_found = remove_comments(text_file_found)
            return text_file_found

    n = 1
    while (n > 0):
        for handle in LIST_HANDLES_INPUT:
            regex = re.compile(CMD_REGEX.format(handle))
            input,n = re.subn(regex,repl,input)

    return input


def integrate_bbl(input,latex_path,input_name):
    def repl(match):
        name, suffix = os.path.splitext(input_name)
        file_found = find_file("{}.bbl".format(name),latex_path)
        with open(file_found) as found_file:
            text_file_found  = found_file.read()
            return text_file_found

    regex = re.compile(CMD_REGEX.format("bibliography"))
    input = re.sub(regex,repl,input)

    return input


def remove_comments(input):
    regex_comments = re.compile(r'((?<!\\)(?:\\{2})*)%(.*)')
    tmp_out_content = ""
    for line in input.splitlines(True):
        match_comment = re.search(regex_comments,line)
        if match_comment:
            line = line.replace(match_comment.group(2),"")
        tmp_out_content+=(line)
    return tmp_out_content



if __name__ == '__main__':
    main()
