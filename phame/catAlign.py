"""
author: nick miller

class GeneCater takes in a fasta files with multiple genes and combines them into 1 sequence.
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

Class prepContigs:
    changes contigs names and
    saves them into /files dir under the working dir

"""
import sys
import read_control
import os


class GeneCater:

    def __init__(self):

        self.gene_map = {}
        control_obj = read_control.ParseFile()
        self.workdir = control_obj.workdir
        self.refdir = control_obj.refdir

    def get_files(self, filename, directory):

        name = ""

        try:
            gene_file = open(filename, "r")
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

        base_file_name = os.path.split(filename)[1]
        filename = base_file_name.split(".")[0]
        filename += ".fna"
        new_file = open(self.workdir+"/files/"+filename, "w+")

        if not self.gene_map:
            pass
        else:
            new_file.writelines(self.gene_map.keys()[0].split()[0] + "\n")
            for item in self.gene_map:

                new_file.writelines(self.gene_map[item] + "\n")


class prepContigs:

        def change_name(self, filename, directory):
            #save file extension as filename_contig.fna in files dir

            #contig renamed to name1, name2 cut after space

            file_handle_original = open(filename, "r")  # open file handle on original file
            base_file_name = os.path.split(filename)[1]  # split full path to just grab the file name
            base_file_name = base_file_name.split(".")[0] # remove file extension
            file_handle_new = open(directory + "/files/"+base_file_name+"_contig.fna", "w") # create new file in /files to write to
            count = 1 # counter for contig number

            for line in file_handle_original:
                if line.startswith(">"):
                    line = ">"+base_file_name+str(count)
                    file_handle_new.writelines(line + "\n")
                    count += 1
                else:
                    file_handle_new.writelines(line)

            file_handle_original.close()
            file_handle_new.close()

