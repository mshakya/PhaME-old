import os
import read_control
import catAlign
import os.path
import sys

from multiprocessing import Pool, Process, Queue, cpu_count

control_file_path = read_control.get_control_file_path.controle_file_path


class CheckFile:

    control_obj = read_control.ParseFile()
    control_obj.read_file(control_file_path)
    refdir = control_obj.refdir
    workdir = control_obj.workdir

    def print_current_settings(self):

        print "Checking control file settings \n"
        if os.path.exists(self.refdir):
            print "reference directory " + self.refdir + "\n"
        else:
            sys.exit(" Could not find " + self.refdir +
                     " Check Phame control file and make sure path is correct")

        if os.path.exists(self.workdir):
            print "working directory " + self.workdir + "\n"
        else:
            sys.exit("Could not find " + self.workdir +
                     " Check Phame control file and make sure path is correct")

    def clean_files(self):
        
        # open files in ref and trim anything after word >
        for file in os.listdir(self.refdir): # iterate through files in ref dir
            file_handle_original = open(os.path.join(self.refdir, file), "r") #get full file path and create fiel handle
            output = []

            for line in file_handle_original:  # iterate through the file
                if ">" in line: # found a header line
                    line = line.split(" ") [0] # remove things after #>NAME
                    line += "\n"
                    output.append(line) # store in output list
                else:
                    output.append(line)
            file_handle_original.close()
            file_handle_new = open(os.path.join(self.refdir, file), "w")  # open file for writing

            for line in output:
                file_handle_new.writelines(line) #  write output to file
            file_handle_new.close()  # close file


class LogFiles:

            control_obj = read_control.ParseFile()
            control_obj.read_file(control_file_path)
            workdir = control_obj.workdir
            resultsdir = workdir+"/results/"

            if os.path.exists(resultsdir):
                pass
            else:
                os.makedirs(resultsdir)

            print "create error file Error.txt and log file logFile.txt in results directory \n"
            error_file = open(resultsdir+"Error.txt", "w+")
            log_file = open(resultsdir+"logFile.txt", "w+")


class GetInputFiles:

    # first send file to catAlign. then have file added to the filelist. BOTH file and filelist should go to output/files
    
    def __init__(self):
        control_obj = read_control.ParseFile()
        control_obj.read_file(control_file_path)
        self.workdir = control_obj.workdir
        self.threads = control_obj.threads

    def parrallelized_file_processing(self, directory):

        if os.path.exists(self.workdir + "/files"):
            pass
        else:
            os.makedirs(self.workdir + "/files")

        file_list = []

        if os.path.exists(directory):

            for file in os.listdir(directory):
                file_path = os.path.join(directory, file)
                file_list.append(file_path)  # create a list of file paths

        for i in range(0, self.threads):
            sub_list = [file_list[j] for j in range(0, len(file_list)) if j % self.threads == i]

            if len(sub_list) > 0:
                p = Process(target=self.get_input_files, args=([sub_list, directory]))  # failing here when only reads in workdir
                p.start()
                p.join()

  #TODO fix hanging when reading files in working dir (seems to be only for .fastq files)
    # possibly fixed. needs testing

    def get_input_files(self, sub_file_list, directory):

        file_list = []

        if os.path.exists(directory):

            for file in sub_file_list:  # walk through the directory
                
                if "." in file:

                    if file.split(".")[1] == "contig" or file.split(".")[1] == "ctg" or file.split(".")[1] == "contigs" \
                            or "contig" in file or "ctg" in file or "contigs" in file:

                        catAlign.GeneCater().get_files(file, directory)
                        file_list.append(os.path.join(directory, file))

                        # create list of contig files for perl scripts to use
                        contig_list = open(self.workdir+"/contig_filelist.txt", "a")
                        base_file_name = os.path.split(file)[1]
                        filename = base_file_name.split(".")[0]
                        filename += "_contig"
                        contig_list.writelines(filename + "\n")

                    ###############################################################
                        # below is now done in catAlign file in write_to_file_contigs function
                    ###############################################################
                        # need to move contig files from workdir to workdir/files.
                        # open a file handle on current contig file.
                        # create a file with the same file name in /files
                        # as you read from original file. write to new file in /files

                    elif file.split(".")[1] == "fa" or file.split(".")[1] == "fna" or file.split(".")[1] == "fasta":
                        # elif "fastq" in file or "fa" in file or "fna" in file or "fasta" in file:

                        catAlign.GeneCater().get_files(file, directory)  # send file to get cated

                        file_list.append(file)

                        fasta_list = open(self.workdir+"/fasta_filelist.txt", "a")
                        base_file_name = os.path.split(file)[1]
                        filename = base_file_name.split(".")[0]
                        fasta_list.writelines(filename + "\n")

                                    # file ==   test_reads.1.fastq
                                    # count number of . in string. if > than 1 go into statment
                    elif file.count(".") > 1:    # this is not catching reads files

                        file_list.append(file)
                        reads_list = open(self.workdir + "/reads_list.txt", "a")

                        if file.split(".")[1] == "1":

                            base_file_name = os.path.split(file)[1]
                            filename = base_file_name.split(".")[0]
                            filename += "_pread"

                            reads_list.writelines(filename + "\n")
                    else:
                        pass
        else:
            sys.exit("could not access " + directory)

        print "\n found the following files in " + directory + " directory \n"
        for item in file_list:
            print item + "\n"

    def create_working_list(self):

        fasta_list = open(self.workdir+"/fasta_filelist.txt", "r")
        working_list = open(self.workdir + "/working_list.txt", "a")

        if os.path.exists(self.workdir + "/contig_filelist.txt"):
            contig_list = open(self.workdir+"/contig_filelist.txt", "r")
            for line in contig_list:
                working_list.writelines(line)

        for line in fasta_list:
            working_list.writelines(line)


