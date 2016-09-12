
"""
author: Nick miller
Phame pipeline in python

DESCRIPTION
   runPhaME.pl is a wrapper to run the PhaME analysis pipeline

USAGE
   Control file "phame.ctl" needs to be copied and editted in the working director.
   This wrapper runs the PhaME pipeline based on the settings of the control file.

REQUIREMENTS
   See PhaME manual for a complete list of system and software requirements
"""


import read_control
import Check_files
import catAlign
import shlex
import subprocess
import os

class RunPhame:

    def __init__(self):
        """" when an instance of runPhame is called do the following
        #read in and parse the control file
        #validate the paths in the control file
        #create error and log files"""

        self.control_file_obj = read_control.ParseFile()
        self.control_file_obj.read_file()
        self.workdir = self.control_file_obj.workdir  # create working directory var to be used later
        self.refdir = self.control_file_obj.refdir    # create reference directory var to be used later

        self.output_dir = self.workdir+"/results"       # create output directory var to be used later

        self.threads = self.control_file_obj.threads  # number of threads from control file
        self.code = self.control_file_obj.code        # bacteria 0, virus 1, or Eukaryote 2

        Check_files.CheckFile().print_current_settings()
        Check_files.LogFiles()
        self.log_file = self.output_dir+"logFile.txt"      # log file to record all messages
        self.error_file = self.output_dir+"Error.txt"      # log file to record errors

        get_input_obj = Check_files.GetInputFiles()  # class instance obj

        self.refdir_file_list = get_input_obj.get_input_files(self.refdir)   # list of files in reference directory
        self.workdir_file_list = get_input_obj.get_input_files(self.workdir)  # list of files in working directory

        if os.path.exists(str(self.workdir)+"/files/fasta_filelist.txt"):
            self.fasta_filelist = str(self.workdir)+"/files/fasta_filelist.txt"
        if os.path.exists(str(self.workdir)+"/files/contig_filelist.txt"):
            self.contig_filelist = str(self.workdir)+"/files/contig_filelist.txt"

        if os.path.exists(self.workdir+"/files"):
            self.files_dir = self.workdir+"/files"

    def prep_ref_files(self):

        catAlign.GeneCater().get_files(self.refdir_file_list, self.output_dir)

    def perl_calls(self, perlArgs):
        # open pipe to perl interp
        # pass multiple command line arguments to Perl scripts using perlArgs

        perlDir = "/users/312793/PhaME/git_phame/phame/perl_scripts/runNUCmer.pl"  # dir to perl scripts
        #pipe = subprocess.Popen(["perl", perl_filename, perlDir, perlArgs])

        args = shlex.split(perlArgs)
        pipe = subprocess.Popen(args, stdout=subprocess.PIPE)

    def runNUCmer(self):

        nucmer = "/users/312793/PhaME/git_phame/phame/perl_scripts/runNUCmer.pl -q " + self.files_dir + " -d " + self.output_dir + " -t " + str(self.threads) + " -l " + \
                 self.fasta_filelist + " -c " + str(self.code) + ">" + self.error_file + ">" + self.log_file
        self.perl_calls(nucmer)

         # self.perl_calls("runNUCmer.pl", "-q", self.workdir, "-d", self.output_dir, "-t", str(self.threads), "-l",
         #                self.fasta_filelist, "-c", str(self.code), ">", self.error_file, ">", self.log_file)
         # comment

    def main(self):
        # call to runNUCmer perl script
        self.runNUCmer()
       


RunPhame()#.main()









