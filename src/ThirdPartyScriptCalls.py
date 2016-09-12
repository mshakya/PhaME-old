

class CompleteNUCmer:

    # bin directory called in Perl for NUCmer
    #bin directory is probably where all the code for the 3rd party stuff is located


    def runContigNUCmer(self, workdir, bindir, workdir_filelist, code, threads, referenece, time, error_file, log_file ):

            contigNucmer = "runContigNucmer.py -r " + referenece + " -q " + workdir + " -l " + workdir_filelist + " t "\
                           + threads + " y " + time + " 2"

    def runNUCmer(self, workdir, bindir, workdir_filelist, type, threads, error_file, log_file):


        pass