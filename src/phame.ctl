      refdir =/Users/nick/PycharmProjects/Phame/phame/test/ref  # directory where reference files are located
      workdir =/Users/nick/PycharmProjects/Phame/phame/test  # directory where contigs/reads files are located and output is stored
      perldir =/Users/nick/PycharmProjects/Phame/phame/perl_scripts  # directory where perl scripts are located


    reference = 1  # 0:pick a random reference; 1:use given reference
      reffile = Ecoli_11368.fna  # reference filename

      project = Ecoli_test  # main alignment file name

      cdsSNPS = 0  # 0:no cds SNPS; 1:cds SNPs

    FirstTime = 1  # 1:yes; 2:update existing SNP alignment

         data = 6  # *See below 0:only complete(F); 1:only contig(C); 2:only reads(R);
                   # 3:combination F+C; 4:combination F+R; 5:combination C+R;
                   # 6:combination F+C+R; 7:realignment  *See below
        reads = 2  # 1: single reads; 2: paired reads; 3: both types present;

         tree = 3  # 0:no tree; 1:use FastTree; 2:use RAxML; 3:use both;
    modelTest = 0  # 0:no; 1:yes; # Only used when building a tree using RAxML
    bootstrap = 1  # 0:no; 1:yes;  # Run bootstrapping  *See below
            N = 100  # Number of bootstraps to run *See below

    PosSelect = 0  # 0:No; 1:use PAML; 2:use HyPhy; 3:use both

         code = 1  # 0:Bacteria; 1:Virus

        clean = 0  # 0:no clean; 1:clean

      threads = 1  # Number of threads to use

       cutoff = 0  # Mismatch cutoff - ignore SNPs within cutoff length of each other.

* When using data option 1,2,5 need a complete reference to align/map to.
* Use data option 7 when need to extract SNPs using a sublist of already aligned genomes.

