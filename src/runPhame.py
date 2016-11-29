
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

        controle_file_path = read_control.get_control_file_path.controle_file_path

        self.control_file_obj = read_control.ParseFile() # create read_control obj
        self.control_file_obj.read_file(controle_file_path)               # call to readin and parse the control file
        self.workdir = self.control_file_obj.workdir  # create working directory var to be used later
        self.refdir = self.control_file_obj.refdir    # create reference directory var to be used later
        self.cdsSNPs = self.control_file_obj.cdsSNPS
        self.data = self.control_file_obj.data

        self.tree = self.control_file_obj.tree

        self.perldir = self.control_file_obj.perldir+"/"   # "/users/312793/PhaME/git_phame/phame/perl_scripts/"  # dir to perl scripts

        self.output_dir = self.workdir+"/results"       # create output directory var to be used later
        
        self.ref_file = self.refdir+"/"+ self.control_file_obj.reffile  # reference file path
        self.ref_file_name = self.control_file_obj.reffile              #ref file name only

        self.threads = self.control_file_obj.threads  # number of threads from control file
        self.code = self.control_file_obj.code        # bacteria 0, virus 1, or Eukaryote 2
        self.project_name = self.control_file_obj.project_name
        self.N = self.control_file_obj.N    # number of bootstraps

        self.type_organism = ""
        self.project_name = self.control_file_obj.project_name
        
        if self.code == 0:
            self.type_organism = "bacteria"
        elif self.code == 1:
            self.type_organism = "virus"
        elif self.code == 2:
            self.type_organism = "eukaryote"

        Check_files.CheckFile().print_current_settings()
        Check_files.CheckFile().clean_files()
        Check_files.LogFiles()
        self.log_file = self.output_dir+"/"+"logFile.txt"      # log file to record all messages
        self.error_file = self.output_dir+"/"+"Error.txt"      # log file to record errors

        get_input_obj = Check_files.GetInputFiles()  # class instance obj

        # parralleized file processing
        get_input_obj.parrallelized_file_processing(self.refdir)   # list of files in reference directory
        get_input_obj.parrallelized_file_processing(self.workdir) # list of files in working directory

        #get_input_obj.get_input_files(self.workdir)
        get_input_obj.create_working_list()

        if os.path.exists(str(self.workdir)+"/fasta_filelist.txt"):
            self.fasta_filelist = str(self.workdir)+"/fasta_filelist.txt"
        if os.path.exists(str(self.workdir)+"/contig_filelist.txt"):
            self.contig_filelist = str(self.workdir)+"/contig_filelist.txt"

        if os.path.exists(self.workdir+"/files"):
            self.files_dir = self.workdir+"/files"

        if os.path.exists(self.workdir+"/working_list.txt"):
            self.working_list = self.workdir+"/working_list.txt"
    
##############################################################

    # def prep_ref_files(self):

    # catAlign.GeneCater().get_files(self.refdir_file_list, self.output_dir)

    def perl_calls(self, perlArgs):
        # open pipe to perl interp
        # pass multiple command line arguments to Perl scripts using perlArgs
        #pipe = subprocess.Popen(["perl"
       status, output = commands.getstatusoutput(perlArgs)

       print str(status) + "\n"
       print str(output) + "\n"
########## alignment and prep functions ##################

    def runNUCmer(self):


        print "Running NUCmer \n"
        nucmer = "perl " + self.perldir + "runNUCmer.pl -q " + self.workdir + " -d " + self.output_dir + " -t " + str(self.threads) + " -l " + \
                 self.fasta_filelist + " -c " + self.type_organism + "  2" + ">" + self.error_file + " > " + self.log_file
        print nucmer
        self.perl_calls(nucmer)

    def runContigNUCmer(self):

        print "\n"
        print "running contig NUCmer \n"
        contigNUCmer = "perl " + self.perldir + "runContigNUCmer.pl -r " + self.ref_file + " -q " + self.workdir + " -d " + self.output_dir + " -l " + self.contig_filelist + " -t " + str(self.threads) + " -y " + str(self.code) +" 2" + ">" + self.error_file + " > " + self.log_file

        print contigNUCmer + "\n"
        self.perl_calls(contigNUCmer)


    def findFastq(self):
        print "finding fastq files  \n "
        findFastq = "perl " + self.perldir+"findFastq.pl " + self.workdir
        print findFastq + "\n"

        self.perl_calls(findFastq)
        

    def readMapping(self):
        print " mapping reads to reference \n "
        readMapping = "perl " + self.perldir+"readsMapping.pl " + self.workdir + " " + self.perldir + " " + self.workdir+"/reads_list.txt" + " " + str(self.threads) + " " + self.project_name + " " + self.error_file + " " + self.log_file
        
        print readMapping + "\n"
        self.perl_calls(readMapping)

        
    def identifyGaps(self):
        
        print " Identifying SNPs \n "
        name = self.ref_file_name.split(".")[0]
        idGaps = "perl " + self.perldir+"identifyGaps.pl "   + self.output_dir + " " + self.working_list  + " " + name + " snp " + self.project_name
    
        print idGaps + "\n"
        self.perl_calls(idGaps)
        
    def buildSNPDB(self):
        print "Building SNP database \n"

        buildSNPDB = "perl " + self.perldir+"buildSNPDB.pl -i " + self.output_dir + " -r " + self.ref_file + " -l " + self.working_list + " -p " + self.project_name + " -c " + str(self.cdsSNPs) + " 2>>"+self.error_file + " >> " + self.log_file
        
        print buildSNPDB + "\n"
        self.perl_calls(buildSNPDB)

    
    def codingRegions(self):
        
        print "finding coding regions \n"
        name  = self.ref_file_name.split(".")[0]

        codingRegions = "perl " +  self.perldir+"codingRegions.pl" + " " + self.output_dir + " " +self.refdir+"/"+name + ".gff"+ " " + name
        print codingRegions + "\n"
        self.perl_calls(codingRegions)

########### Tree generations functions ################
    
    def modelTest(self):
        print "running  Jmodel test \n"
        jmodelJar = self.workdir+"/../ext/opt/jmodeltest-2.1.10/jModelTest.jar"
        outfile = self.output_dir+"/"+self.project_name+"/_modelTest.txt"
        infile = self.output_dir+"/"+self.project_name+"/_all_snp_alignment.fna"

        modelTest = "java -jar " + jmodelJar + " -d " + infile + " -f -i -g 4 -s 11 -AIC -a tr " + str(self.threads) + " > " + outfile
        print modelTest
        self.perl_calls(modelTest)

    def buildTree(self, tree):
            
        print "Building tree \n"
        Tree = "perl " +self.perldir+"buildTree.pl " +  self.perldir + " " + self.output_dir + " " + str(self.threads) + " " + str(tree) + " " + self.project_name+"_all" + " " + self.error_file + " " + self.log_file
        print Tree
        self.perl_calls(Tree)


    def bootstrap(self, tree):
        
        print "running Bootstrap " + str(self.N) + " times \n"
        bootstrap = "perl " +self.perldir+"bootstrap.pl " + self.perldir + " " + self.output_dir + " " + str(self.threads) + " " + str(tree) + " " + self.project_name+"_all" + " " + str(self.N) + " " + self.error_file + " " + self.log_file
        
        print bootstrap
        self.perl_calls(bootstrap)


    def treeCleanUp(self, tree):
        
        print " cleaning up tree files \n "
        treeCleanUp = "perl " +self.perldir+"treeCleanUp.pl " + self.refdir + " " + str(tree) + " " + self.output_dir

        print treeCleanUp
        self.perl_calls(treeCleanUp)

########### Molecular Evolution functions #############
## TODO NEEDS TESTINGGGGGGGGGGGGGGGGGGG   ######
        

    def extractGenes(self):
        print " extracting genes \n"

        extractGenes = "perl " + self.perldir+"extractGenesOutter.pl " + self.output_dir + " " + self.output_dir+"/"+self.project_name+"_stats.txt" + " " + self.ref_file + " " + self.perldir + " " + self.working_list + " " + str(self.threads) + " " + self.output_dir+"/"+self.project_name+"_gaps.txt" + " " + self.refdir+"/"+self.ref_file_name+".gff" + " " + self.error_file + " " + self.log_file
        
        print extractGenes
        self.perl_calls(extractGenes)


    def geneAction(self, geneAction):

        #function used for translation, alignment, and revTrans
        #geneAction = translate, mafft, or pal2nal

        print "translate genes \n "
        translateGenes = "perl " + self.perldir+"parallel_run.pl -d " + self.output_dir+"/PSgenes" + " -t " + str(self.threads) + " -m " + geneAction  +  " 2>>"+self.error_file + " >> " + self.log_file

        print translateGenes
        self.perl_calls(translateGenes)

    def core(self):

        print "Core gene alignment \n "
        core = "perl " + self.perldir+"faatAlign.pl " + self.output_dir+"/PSgenes" + " " + self.output_dir+"/PSgene/"+self.project_name+"_core_genome.cdn" + " 2>>"+self.error_file + " >> " + self.log_file


    def paml(self):

        ptree = ""

        if self.tree == 2 or self.tree == 3:
            ptree = self.output_dir+"/paml/RAxML_bestTree."+self.project_name+"_cds"
        else:
            ptree = self.output_dir+"/paml/"+self.project_name+".fasttree"


        print " running paml \n "
        model_0 = "perl " + self.perl_dir+"runPAML.pl -i " + " " + self.output_dir + " -t " + str(self.threads) + " -r " + ptree + " -m " + " 0 " + " -n " + " 1,2 " + " -s " +  " Sites " + " -c " + self.output+"/paml/"+self.project_name+"_core_genome.cdn" + " 2>>"+self.error_file + " >> " + self.log_file 

        print model_0 + "\n"
        self.perl_calls(model_0)

        parseSite = "perl " + self.perl_dir+"parseSitePAML.pl " + self.output_dir+"/paml" + " " + " 1,2 " + "2>>"+self.error_file + " >> " + self.log_file
        print parseSite + "\n"
        self.perl_calls(parseSite)

        parseTree = "perl " + self.perl_dir+"ParseTree.pl " + str(self.tree) + " 2>>"+self.error_file + " >> " + self.log_file
        print parseTree + "\n"
        self.perl_calls(parseTree)

    
        ps = "perl " + self.perl_dir+"runPAML.pl " + " -i "+ self.output_dir + " -t " + str(self.threads) + " -r " + ptree + " -m " + " 2 " + " -n " +  " 2 " + " -s " + "BrSites" + " -c " + self.output+"/paml/"+self.project_name+"_core_genome.cdn" + " 2>>"+ self.error_file + " >> " + self.log_file
        print ps + "\n"
        self.perl_calls(ps)

        move = self.output_dir+"/paml/*/*BrSites" + self.output_dir+"/paml"
        self.perl_calls(move)
    
        parse = "perl " + self.perl_dir+"parseSitePAML.pl" + " " + self.output_dir+"/paml" + " 0,1,2,7,8," + "2" + " 2>>" + self.error_file + " >> " + self.log_file
        print parse + "\n"
        self.perl_calls(parse)



    def hyphy(self):
        
        rootedtree = ""
        if self.tree == 2 or self.tree == 3:
            rootedtree = self.output_dir+"/RAxML_rootedTree."+self.project_name+"_cds_r"
        else:
            rootedtree = self.output_dir+"/"+self.project_name+"_cds_rooted.fasttree"

        if self.tree == 2 or self.tree == 3:
            ptree = self.output_dir+"/paml/RAxML_bestTree."+self.project_name+"_cds"
        else:
            ptree = self.output_dir+"/paml/"+self.project_name+".fasttree"
        
        hyphy = "perl " + self.perl_dir+"runHyPhy.pl " + " -i " + self.output_dir + " -t " + str(int(self.threads/2)) + " -r " + ptree + " o " + rootedtree + " -c " + self.output + "/paml/"+self.project_name + "_core_genome.cdn" + " 2>>" + self.error_file + " >> " + self.log_file
    

################ Main call #######################
###  call above funcitons.  ###
##################################################

    def run_parameters(self):
        # set up PhaME pipeline calls for SNP extraction and alignment

        if self.data is 0:
            self.runNUCmer()
                    
            if self.cdsSNPs is 1:
                self.codingRegions()

            self.identifyGaps()
            self.buildSNPDB()

        elif self.data is 1:
            self.runContigNUCmer()
            
            if self.cdsSNPs is 1:
                self.codingRegions()

            self.identifyGaps()
            self.buildSNPDB()

        elif self.data is 2:
            
            self.findFastq()
            self.identifyGaps()
            self.readMapping()

            if self.cdsSNPs is 1:
                self.codingRegions()

            self.identifyGaps()
            self.buildSNPDB()

        elif self.data is 3:
            self.runNUCmer()
            self.runContigNUCmer()

            if self.cdsSNPs is 1:
                self.codingRegions()

            self.identifyGaps()
            self.buildSNPDB()

        elif self.data is 4:

            self.findFastq()
            self.runNUCmer()
            self.identifyGaps()
            self.readMapping()

            if self.cdsSNPs is 1:
                self.codingRegions()

            self.identifyGaps()
            self.buildSNPDB()

        elif self.data is 5:

            self.findFastq()
            self.runContigNUCmer()
            self.identifyGaps()
            self.readMapping()

            if self.cdsSNPs is 1:
                self.codingRegions()

            self.identifyGaps()
            self.buildSNPDB()

        elif self.data is 6:

            self.findFastq()
            self.runNUCmer()
            self.runContigNUCmer()
            self.identifyGaps()
            self.readMapping()

            if self.cdsSNPs is 1:
                self.codingRegions()

            self.identifyGaps()
            self.buildSNPDB()

        elif self.data is 7:
            
            self.findFastq()

            if self.cdsSNPs is 1:
                self.codingRegions()

            self.identifyGaps()
            self.buildSNPDB()

    # calls to build trees

        if self.tree  > 0:

            if self.tree is 2 or self.tree is 3:
                self.buildTree(self.tree)
                self.bootstrap(2)
                self.treeCleanUp(self.tree)
            else:
                self.buildTree(self.tree)
                self.treeCleanUp(self.tree)
        
        print " \n PhaME run complete. Check the results folder \n "
        print " please view the Error.txt file in the results folder to see if any issues were encountered during the run \n"
        print " The logFile.txt file in the results folder contains information about the run \n"

    def main(self):
        
        self.run_parameters()

       # TODO impliment 
       #self.modelTest()   # not yet implimented


RunPhame().main()


