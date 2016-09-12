"""
author: nick miller

This script takes in a fasta files with multiple genes and combines them into 1 sequence.
Genes within the fasta files are cated together

ex:
    file A
    >gene a:
    ACTG


    >gene B:
    TATTA

    output file
    >genes:
    ACTGTATTA
"""
import sys
import read_control

class GeneCater:

    def __init__(self):

        self.gene_map = {}
        control_obj = read_control.ParseFile()
        self.workdir = control_obj.workdir


    def get_files(self, filename, directory):

        gene_file = ""
        name = ""

        #for single_file in files_list:
        #filename = single_file

        try:
            gene_file = open(directory+"/"+filename, "r")
        except IOError:
            print "Could not open \n" + str(filename)
            sys.exit("ERROR could not open " + str(filename))

        for line in gene_file:
            if line == "\n":
                continue
            elif line[0] == ">":
                line = line.rstrip('\n')
                name = line.split("|", 1)[0]
                value = ""
            else:
                line = line.rstrip('\n')
                value = line
            self.add_to_gene_map(name, value)

        self.write_to_file(self.workdir+"/files/", filename)

    def add_to_gene_map(self, name, value):

        if name not in self.gene_map:
            self.gene_map[name] = value
        else:
            curr_val = self.gene_map[name]
            self.gene_map[name] = curr_val + value

    def write_to_file(self, output_dir, filename):

        new_file = open(output_dir+filename, "w+")

        new_file.writelines(self.gene_map.keys()[0].split()[0] + "\n")

        for item in self.gene_map:
            #new_file.writelines(item + "\n")
            #new_file.writelines(item.split()[0] + "\n")
            new_file.writelines(self.gene_map[item] + "\n")

# testing purposes
# def main():
#
#     filename = "KJ660347.fasta"
#     directory = "/Users/nick/PycharmProjects/PhaME/test/ref/"
#
#     GeneCater().get_files(directory+filename, "/Users/nick/PycharmProjects/PhaME/src")
#
# main()