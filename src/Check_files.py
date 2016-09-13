import os
import read_control
import catAlign
import os.path
import sys


class CheckFile:

    control_obj = read_control.ParseFile()
    control_obj.read_file()
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


class LogFiles:

            control_obj = read_control.ParseFile()
            control_obj.read_file()
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

    #TODO first send file to catAlign. then have file added to the filelist. BOTH file and filelist should go to output/files

    def get_input_files(self, directory):

        control_obj = read_control.ParseFile()
        control_obj.read_file()
        workdir = control_obj.workdir

        if os.path.exists(workdir + "/files"):
            pass
        else:
            os.makedirs(workdir + "/files")

        file_list = []

        if os.path.exists(directory):

            for file in os.listdir(directory):  # walk through the directory
                
                if "." in file:

                    if file.split(".")[1] == "contig" or file.split(".")[1] == "ctg" or file.split(".")[1] == "contigs":
                      
			file_list.append(os.path.join(directory, file))
                        contig_file = os.path.join(directory,file)

                        #create list of contig files for perl scripts to use
                        contig_list = open(workdir+"/files/contig_filelist.txt", "a")
                        filename = file.split(".")[0]
                        contig_list.writelines(filename + "\n")

                        # need to move contig files from workdir to workdir/files.
                        # open a file handle on current contig file.
                        # create a file with the same file name in /files
                        # as you read from original file. write to new file in /files
                        output_contig_file_handle = open(workdir+"/files/"+file, "w")
                        contig_file_handle = open(contig_file, "r")
                        for line in contig_file_handle:
                            output_contig_file_handle.writelines(line)


                    elif file.split(".")[1] == "fastq" or file.split(".")[1] == "fa" \
                            or file.split(".")[1] == "fna" or file.split(".")[1] == "fasta":

                        catAlign.GeneCater().get_files(file, directory)  # send file to get cated

                        file_list.append(os.path.join(workdir+"/files/", file))
                        fasta_list = open(workdir+"/files/fasta_filelist.txt", "a")
			filename = file.split(".")[0]
                        fasta_list.writelines(filename + "\n")

                        # add full filepath to a list. use that list to access files when needed
        else:
            sys.exit("could not access " + directory)

        print "\n found the following files in " + directory + " directory \n"
        for item in file_list:
            print item + "\n"

        return file_list



