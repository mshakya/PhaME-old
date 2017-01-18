#!/usr/bin/env bash

set -e # Exit as soon as any line in the bash script fails

ROOTDIR=$( cd $(dirname $0) ; pwd -P ) # path to main PhaME directory

echo
exec &> >(tee -a  install.log)
exec 2>&1 # copies stderr onto stdout

# create a directory where all dependencies will be installed
cd $ROOTDIR
mkdir -p thirdParty
cd thirdParty


################################################################################
done_message () {
   if [ $? == 0 ]; then
      if [ "x$1" != "x" ]; then
          echo $1;
      else
          echo "done.";
      fi
   else
      echo "Installation failed." $2
      exit 1;
   fi
}

download_ext () {
   if [ -e $2 ]; then
      echo "$2 existed. Skiping downloading $1."
      return;
   fi;

   if hash curl 2>/dev/null; then
    if [[ -n ${HTTP_PROXY} ]]; then
          echo "Using proxy";
          echo "curl --proxy $HTTP_PROXY -L $1 -o $2";
          which curl
          curl --proxy $HTTP_PROXY -L $1  -o $2;
        else
      echo "curl -L \$1 -o \$2";
      #echo "Not using proxy";
      curl -L $1 -o $2;
    fi;
   else
      wget -O $2 $1;
   fi;

   if [ ! -r $2 ]; then
      echo "ERROR: $1 download failed."
   fi;
}

################################################################################
install_miniconda()
{
echo "--------------------------------------------------------------------------
                           downloading miniconda
--------------------------------------------------------------------------------
"

if [[ "$OSTYPE" == "darwin"* ]]
then
{

  curl -o miniconda.sh https://repo.continuum.io/miniconda/Miniconda2-4.2.12-MacOSX-x86_64.sh
  chmod +x miniconda.sh
  ./miniconda.sh -b -p $ROOTDIR/thirdParty/miniconda -f
  export PATH=$ROOTDIR/thirdParty/miniconda/bin:$PATH
}
else
{  

  wget https://repo.continuum.io/miniconda/Miniconda2-4.2.12-Linux-x86_64.sh -O miniconda.sh
  chmod +x miniconda.sh
  ./miniconda.sh -b -p $ROOTDIR/thirdParty/miniconda -f
  export PATH=$ROOTDIR/thirdParty/miniconda/bin:$PATH

}
fi
}

################################################################################
checkSystemInstallation()
{
    IFS=:
    for d in $PATH; do
      if test -x "$d/$1"; then return 0; fi
    done
    return 1
}

checkPerlModule()
{
   perl -e "use lib \"$rootdir/lib\"; use $1;"
   return $?
}

################################################################################
install_mummer()
{
echo "--------------------------------------------------------------------------
                           installing mummer v3.23
--------------------------------------------------------------------------------
"
conda install --yes -c bioconda mummer=3.23
echo "
------------------------------------------------------------------------------
                           mummer v3.23 installed
------------------------------------------------------------------------------
"
}

install_cmake()
{
echo "--------------------------------------------------------------------------
                           installing cmake v3.0.1
--------------------------------------------------------------------------------
"
conda install --yes -c anaconda cmake=3.0.1
echo "
------------------------------------------------------------------------------
                           cmake v3.0.1 installed
------------------------------------------------------------------------------
"
}

install_bwa()
{
echo "------------------------------------------------------------------------------
                           Downloading bwa v0.7.15
------------------------------------------------------------------------------
"
conda install --yes -c bioconda bwa=0.7.15
echo "
------------------------------------------------------------------------------
                           bwa v0.7.15 installed
------------------------------------------------------------------------------
"
}

install_bowtie2()
{
echo "--------------------------------------------------------------------------
                           installing bowtie2 v2.2.8
--------------------------------------------------------------------------------
"
conda install --yes -c bioconda bowtie2=2.2.8
echo "
------------------------------------------------------------------------------
                           bowtie2 v2.2.8 installed
------------------------------------------------------------------------------
"
}

install_samtools()
{
echo "--------------------------------------------------------------------------
                           Downloading samtools v1.3.1
--------------------------------------------------------------------------------
"
conda install --yes -c bioconda samtools=1.3.1
echo "
--------------------------------------------------------------------------------
                           samtools v1.3.1 installed
--------------------------------------------------------------------------------
"
}

install_fasttree()
{
echo "--------------------------------------------------------------------------
                           Downloading fasttree v2.1.9
--------------------------------------------------------------------------------
"
conda install --yes -c bioconda fasttree=2.1.9
echo "
--------------------------------------------------------------------------------
                           fasttree v2.1.9
--------------------------------------------------------------------------------
"
}

install_raxml()
{
echo "--------------------------------------------------------------------------
                           Downloading raxml v8.2.9
--------------------------------------------------------------------------------
"
conda install --yes -c bioconda raxml=8.2.9
echo "
--------------------------------------------------------------------------------
                           raxml v8.2.9
--------------------------------------------------------------------------------
"
}

install_muscle()
{
echo "--------------------------------------------------------------------------
                           Downloading muscle v3.8.31
--------------------------------------------------------------------------------
"
conda install --yes -c bioconda muscle=3.8.31
echo "
--------------------------------------------------------------------------------
                           muscle v3.8.31
--------------------------------------------------------------------------------
"
}

install_mafft()
{
echo "--------------------------------------------------------------------------
                           Downloading mafft v7.305
--------------------------------------------------------------------------------
"
conda install --yes -c bioconda mafft=7.305
echo "
--------------------------------------------------------------------------------
                           mafft v7.305
--------------------------------------------------------------------------------
"
}

install_paml()
{
echo "--------------------------------------------------------------------------
                           Downloading paml v4.9
--------------------------------------------------------------------------------
"
conda install --yes -c bioconda paml=4.9
echo "
--------------------------------------------------------------------------------
                           paml v4.9
--------------------------------------------------------------------------------
"
}



install_perl_Getopt_Long()
{
echo "--------------------------------------------------------------------------
                           installing Perl Module Getopt::Long
--------------------------------------------------------------------------------
"
cpanm Getopt::Long
echo "
--------------------------------------------------------------------------------
                           Getopt::Long installed
--------------------------------------------------------------------------------
"
}

install_perl_Statistics_Distributions()
{
echo "--------------------------------------------------------------------------
                           installing Perl Module Statistics::Distributions 
--------------------------------------------------------------------------------
"
cpanm Statistics::Distributions 
echo "
--------------------------------------------------------------------------------
                          Statistics::Distributions installed
--------------------------------------------------------------------------------
"
}

install_perl_Time_HiRes()
{
echo "--------------------------------------------------------------------------
                           installing Perl Module Time::HiRes
--------------------------------------------------------------------------------
"
cpanm Time::HiRes
echo "
--------------------------------------------------------------------------------
                          Time::HiRes Resinstalled
--------------------------------------------------------------------------------
"
}

install_perl_File_Path()
{
echo "--------------------------------------------------------------------------
                           installing Perl Module File::Path
--------------------------------------------------------------------------------
"
cpanm File::Path
echo "
--------------------------------------------------------------------------------
                          File::Path Resinstalled
--------------------------------------------------------------------------------
"
}

install_perl_File_Basename()
{
echo "--------------------------------------------------------------------------
                           installing Perl Module File::Basename
--------------------------------------------------------------------------------
"
cpanm File::Basename
echo "
--------------------------------------------------------------------------------
                          File::Basename Resinstalled
--------------------------------------------------------------------------------
"
}

install_perl_File_Basename()
{
echo "--------------------------------------------------------------------------
                           installing Perl Module File::Copy
--------------------------------------------------------------------------------
"
cpanm File::Copy
echo "
--------------------------------------------------------------------------------
                          File::Copy Resinstalled
--------------------------------------------------------------------------------
"
}

install_perl_IO_Handle()
{
echo "--------------------------------------------------------------------------
                           installing Perl Module IO::Handle
--------------------------------------------------------------------------------
"
cpanm IO::Handle
echo "
--------------------------------------------------------------------------------
                           IO::Handle Resinstalled
--------------------------------------------------------------------------------
"
}


install_perl_Parallel_ForkManager()
{
echo "--------------------------------------------------------------------------
                           installing Perl Module Parallel::ForkManager
--------------------------------------------------------------------------------
"
cpanm Parallel::ForkManager
echo "
--------------------------------------------------------------------------------
                           Parallel::ForkManager Resinstalled
--------------------------------------------------------------------------------
"
}
################################################################################
if ( checkSystemInstallation conda )
then
  echo "conda is found"
else
  echo "conda is not found"
  install_miniconda
fi

if ( checkSystemInstallation mummer )
then
  echo "mummer is found"
else
  echo "mummer is not found"
  install_mummer
fi


if ( checkSystemInstallation bwa )
then
  echo "bwa is found"
else
  echo "bwa is not found"
  install_bwa
fi

if ( checkSystemInstallation bowtie2 )
then
  echo "bowtie2 is found"
else
  echo "bowtie2 is not found"
  install_bowtie2
fi

if ( checkSystemInstallation samtools )
then
  echo "samtools is found"
else
  echo "samtools is not found"
  install_samtools
fi

if ( checkSystemInstallation FastTree )
then
  echo "fasttree is found"
else
  echo "fasttree is not found"
  install_fasttree
fi

if ( checkSystemInstallation raxmlHPC )
then
  echo "raxml is found"
else
  echo "raxml is not found"
  install_raxml
fi

if ( checkSystemInstallation muscle )
then
  echo "muscle is found"
else
  echo "muscle is not found"
  install_muscle
fi

if ( checkSystemInstallation mafft )
then
  echo "mafft is found"
else
  echo "mafft is not found"
  install_mafft
fi

if ( checkSystemInstallation codeml )
then
  echo "paml is found"
else
  echo "paml is not found"
  install_paml
fi

if ( checkPerlModule Getopt::Long )
then
  echo "Perl Getopt::Long is found"
else
  echo "Perl Getopt::Long is not found"
  install_perl_Getopt_Long
fi

if ( checkPerlModule Time::HiRes )
then
  echo "Perl Time::HiRes is found"
else
  echo "Perl Time::HiRes is not found"
  install_perl_Time_HiRes
fi

if ( checkPerlModule File::Path )
then
  echo "Perl File::Path is found"
else
  echo "Perl File::Path is not found"
  install_perl_File_Path
fi

if ( checkPerlModule File::Basename )
then
  echo "Perl File::Basename is found"
else
  echo "Perl File::Basename is not found"
  install_perl_File_Basename
fi

if ( checkPerlModule File::Copy )
then
  echo "Perl File::Copy is found"
else
  echo "Perl File::Copy is not found"
  install_perl_File_Copy
fi

if ( checkPerlModule IO::Handle )
then
  echo "Perl IO::Handle is found"
else
  echo "Perl IO::Handle is not found"
  install_perl_IO_Handle
fi


if ( checkPerlModule Parallel::ForkManager )
then
  echo "Perl Parallel::ForkManager is found"
else
  echo "Perl Parallel::ForkManager is not found"
  install_perl_Parallel_ForkManager
fi

if ( checkPerlModule Statistics::Distributions )
then
  echo "Perl Statistics::Distributions is found"
else
  echo "Perl Statistics::Distributions is not found"
  install_perl_Statistics_Distributions
fi


################################################################################



# echo "Checking PAL2NAL ..."

# PAL2NAL_VER=`pal2nal.pl 2>&1 | grep "pal2nal.pl" |  perl -nle 'print $& if m{v\d+}' | perl -nle 'print $& if m{\d+}' `;

# if ( hash pal2nal.pl 2>/dev/null ) && ( echo $PAL2NAL_VER | awk '{if($1>="14") exit 0; else exit 1}' )
# then
#    echo "PAL2NAL >=14 found.";
# else
#    echo "PAL2NAL >=14 not found. Trying to download from http://www.bork.embl.de/pal2nal/distribution/pal2nal.v14.tar.gz ...";
#    download_ext http://www.bork.embl.de/pal2nal/distribution/pal2nal.v14.tar.gz pal2nal.v14.tar.gz;
#    tar xvzf pal2nal.v14.tar.gz
#    cd $ROOTDIR/thirdParty;
#    pwd;
#    cp pal2nal.v14/pal2nal.pl $ROOTDIR/;
# fi;
# done_message " Done." "";



# echo "Checking jModeltest ..."
# if [ -f "$ROOTDIR/ext/opt/jmodeltest-2.1.10/jModelTest.jar" ]
# then
#   echo "jModeltest found";
# else
#   echo "jModeltest not found. Trying to download from https://github.com/ddarriba/jmodeltest2/files/157117/jmodeltest-2.1.10.tar.gz ...";
#   mkdir -p ext/opt;
#   mkdir -p ext/bin;
#   download_ext https://github.com/ddarriba/jmodeltest2/files/157117/jmodeltest-2.1.10.tar.gz ext/opt/jmodeltest-2.1.10.tar.gz;
#   cd ext/opt/
#   tar xvzf jmodeltest-2.1.10.tar.gz
#   cd $ROOTDIR
# fi


echo "Checking HyPhy ..."

HyPhy_VER=`echo -e "1\n2\n3" | HYPHYMP  2>&1 | grep HYPHY | perl -nle 'print $& if m{\d+\.\d+}'`;

if ( hash HYPHYMP 2>/dev/null ) && ( echo $HyPhy_VER | awk '{if($_>="2.2") exit 0; else exit 1}' )
then
   echo "HyPhy >=2.2 found.";
else
   echo "HyPhy >=2.2 not found. Trying to download from https://github.com/veg/hyphy/archive/2.2.7.zip...";
   mkdir -p ext/opt;
   mkdir -p ext/bin;
   conda install --yes -c conda-forge ca-certificates=2016.9.26
   download_ext https://github.com/veg/hyphy/archive/2.2.7.zip ext/opt/HyPhy.zip;
   unzip ext/opt/HyPhy.zip -d ext/opt/;
   cd ext/opt/hyphy-master;
   cmake -DINSTALL_PREFIX=$ROOTDIR/ext
   make MP2 && make install
   make GTEST
    ./HYPHYGTEST
   cd $ROOTDIR
fi;
done_message " Done." "";



################################################################################
#                       Add path to bash
################################################################################
if [ -f $HOME/.bashrc ]
then
{
  echo "#Added by PhaME pipeline installation" >> $HOME/.bashrc
  echo "export PATH=$ROOTDIR/thirdParty/miniconda/bin:$PATH" >> $HOME/.bashrc
  source $HOME/.bashrc 
  echo "
--------------------------------------------------------------------------------
                           added path to .bashrc
--------------------------------------------------------------------------------
"
}
else
{
  echo "#Added by PhaME pipeline installation" >> $HOME/.bash_profile
  echo "export PATH=$ROOTDIR/thirdParty/miniconda/bin:$PATH" >> $HOME/.bash_profile
  source $HOME/.bash_profile 
  echo "
--------------------------------------------------------------------------------
                           added path to .bash_profile
--------------------------------------------------------------------------------
"
}
fi

echo "
================================================================================
                 PhaME installed successfully.
================================================================================
Check phame.ctl for the control file

Quick start:
    bin/runPhaME.pl phame.ctl
Check our github site for update:
    https://github.com/LANL-Bioinformatics/PhaME
";
