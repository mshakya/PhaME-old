
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
import commands

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
        self.cdsSNPs = self.control_file_obj.cdsSNPS
	    
	    # TODO perldir needs to not be hard codeded. Not sure how to auto grab this since is depends on install location
        self.perldir = "/users/312793/PhaME/git_phame/phame/perl_scripts/"  # dir to perl scripts

        self.output_dir = self.workdir+"/results"       # create output directory var to be used later
        
        self.ref_file = self.control_file_obj.reffile

        self.threads = self.control_file_obj.threads  # number of threads from control file
        self.code = self.control_file_obj.code        # bacteria 0, virus 1, or Eukaryote 2
        self.project_name = self.control_file_obj.project_name


        self.type_organism = ""
        self.project_name = self.control_file_obj.project_name
        
        if self.code == 0:
		    self.type_organism = "bacteria"
        elif self.code == 1:
		    self.type_organism = "virus"
        elif self.code == 2:
		    self.type_organism = "eukaryote"
	

        Check_files.CheckFile().print_current_settings()
        Check_files.LogFiles()
        self.log_file = self.output_dir+"/"+"logFile.txt"      # log file to record all messages
        self.error_file = self.output_dir+"/"+"Error.txt"      # log file to record errors

        get_input_obj = Check_files.GetInputFiles()  # class instance obj

        self.refdir_file_list = get_input_obj.get_input_files(self.refdir)   # list of files in reference directory
        self.workdir_file_list = get_input_obj.get_input_files(self.workdir)  # list of files in working directory
        get_input_obj.create_working_list()

        if os.path.exists(str(self.workdir)+"/fasta_filelist.txt"):
            self.fasta_filelist = str(self.workdir)+"/fasta_filelist.txt"
        if os.path.exists(str(self.workdir)+"/contig_filelist.txt"):
            self.contig_filelist = str(self.workdir)+"/contig_filelist.txt"

        if os.path.exists(self.workdir+"/files"):
            self.files_dir = self.workdir+"/files"

        if os.path.exists(self.workdir+"/working_list.txt"):
            self.working_list = self.workdir+"/working_list.txt"

    def prep_ref_files(self):

        catAlign.GeneCater().get_files(self.refdir_file_list, self.output_dir)

    def perl_calls(self, perlArgs):
        # open pipe to perl interp
        # pass multiple command line arguments to Perl scripts using perlArgs
        #pipe = subprocess.Popen(["perl"
        commands.getstatusoutput(perlArgs)

    def runNUCmer(self):
		# hard coding virius or bacteria since its a little off from original command
        print "\n"
        nucmer = "perl /users/312793/PhaME/git_phame/phame/perl_scripts/runNUCmer.pl -q " + self.workdir + " -d " + self.output_dir + " -t " + str(self.threads) + " -l " + \
                 self.fasta_filelist + " -c " + self.type_organism + "  2" + ">" + self.error_file + " > " + self.log_file
        print nucmer
        self.perl_calls(nucmer)

    def runContigNUCmer(self):

        print "\n"
        print "running contig NUCmer \n"
        contigNUCmer = "perl " + self.perldir + "runContigNUCmer.pl -r " + self.ref_file + " -q " + self.workdir + " -d " + self.output_dir + " -l " + self.contig_filelist + " -t " + str(self.threads) + " -y " + str(self.code) +" 2" + ">" + self.error_file + " > " + self.log_file

        print contigNUCmer + "\n"
        self.perl_calls(contigNUCmer)

    def identifyGaps(self):
        
        print " Identifying SNPs \n "
        name = self.ref_file.split(".")[0]
        idGaps = "perl " + self.workdir + " " + self.working_list  + " " + name + " snp " + self.project_name

        print idGaps + "\n"
        self.perl_calls(idGaps)

    def buildSNPDB(self):
        print "\n"

        buildSNPDB = "perl " self.perldir+"buildSNPDB.pl -i" + self.output_dir + " -r " + self.ref_file + " l " + self.working_list + " -p " + self.project_name + " -c " + str(self.cdsSNPs) + "2>>"+self.error_file + " >> " + self.log_file
        
        print buildSNPDB + "\n"
        self.perl_calls(buildSNPDB)
        

    def main(self):
        # call to runNUCmer perl script
        #self.runNUCmer()
        #self.runContigNUCmer()
        #self.identifyGaps()
        self.buildSNPDB()


RunPhame().main()


