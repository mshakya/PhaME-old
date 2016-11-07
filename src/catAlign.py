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
        self.refdir = control_obj.refdir

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
                line = line.split(" ")[0]
                name = line.split("|", 1)[0]
                value = ""
            else:
                line = line.rstrip('\n')
                value = line
            self.add_to_gene_map(name, value)

        if directory == self.refdir:
            self.write_to_file(self.workdir+"/files/", filename)
        elif directory == self.workdir:
            self.write_to_file(self.workdir+"/files/", filename)   

    def add_to_gene_map(self, name, value):

        if name not in self.gene_map:
            self.gene_map[name] = value
        else:
            curr_val = self.gene_map[name]
            self.gene_map[name] = curr_val + value

    def write_to_file(self, output_dir, filename):
        
        filename = filename.split(".")[0]
        filename += ".fna"
        new_file = open(output_dir+filename, "w+")

        if not self.gene_map:
            pass
        else:
            new_file.writelines(self.gene_map.keys()[0].split()[0] + "\n")
            for item in self.gene_map:
                #new_file.writelines(item + "\n")
                #new_file.writelines(item.split()[0] + "\n")
                new_file.writelines(self.gene_map[item] + "\n")

    def write_to_file_contigs(self, output_dir, filename):

        filename = filename.split(".")[0]
        filename += "_contig.fna"
        new_file = open(output_dir+filename, "w+")

        if not self.gene_map:
            pass
        else:
            new_file.writelines(self.gene_map.keys()[0].splie()[0] + "\n") #writes the header

            for item in self.gene_map:
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
