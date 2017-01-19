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

# Minimum Required versions of dependencies
miniconda_VER=4.2.12
R_VER=3.3.1
bowtie2_VER=2.2.8
# nucmer 3.1 is packaged in mummer 3.23
mummer_VER=3.1
cmake_VER=3.0.1
bwa_VER=0.7.15
samtools_VER=1.3.1
FastTree_VER=2.1.9
RAxML_VER=8.2.9
muscle_VER=3.8.31
mafft_VER=7.305
paml_VER=4.9
cpanm_VER=1.7039

#minimum required version of Perl modules
perl_Getopt_Long_VER=2.45

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


checkLocalInstallation()
{
    IFS=:
    for d in $ROOTDIR/thirdParty/miniconda/bin; do
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
install_cpanm()
{
echo "--------------------------------------------------------------------------
                           installing cpanm v1.7039
--------------------------------------------------------------------------------
"
conda install --yes -c bioconda perl-app-cpanminus=1.7039 -p $ROOTDIR/thirdParty/miniconda
echo "
------------------------------------------------------------------------------
                           mummer v3.23 installed or nucmer 3.21
------------------------------------------------------------------------------
"  
}

install_mummer()
{
echo "--------------------------------------------------------------------------
                           installing mummer v3.23 or nucmer 3.21
--------------------------------------------------------------------------------
"
conda install --yes -c bioconda mummer=3.23 -p $ROOTDIR/thirdParty/miniconda
echo "
------------------------------------------------------------------------------
                           mummer v3.23 installed or nucmer 3.21
------------------------------------------------------------------------------
"
}

install_cmake()
{
echo "--------------------------------------------------------------------------
                           installing cmake v3.0.1
--------------------------------------------------------------------------------
"
conda install --yes -c anaconda cmake=3.0.1 -p $ROOTDIR/thirdParty/miniconda
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
conda install --yes -c bioconda bwa=0.7.15 -p $ROOTDIR/thirdParty/miniconda
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
conda install --yes -c bioconda bowtie2=2.2.8 -p $ROOTDIR/thirdParty/miniconda
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
conda install --yes -c bioconda samtools=1.3.1 -p $ROOTDIR/thirdParty/miniconda
echo "
--------------------------------------------------------------------------------
                           samtools v1.3.1 installed
--------------------------------------------------------------------------------
"
}

install_FastTree()
{
echo "--------------------------------------------------------------------------
                           Downloading FastTree v2.1.9
--------------------------------------------------------------------------------
"
conda install --yes -c bioconda FastTree=2.1.9 -p $ROOTDIR/thirdParty/miniconda
echo "
--------------------------------------------------------------------------------
                           FastTree v2.1.9
--------------------------------------------------------------------------------
"
}

install_RAxML()
{
echo "--------------------------------------------------------------------------
                           Downloading RAxML v8.2.9
--------------------------------------------------------------------------------
"
conda install --yes -c bioconda RAxML=8.2.9 -p $ROOTDIR/thirdParty/miniconda
echo "
--------------------------------------------------------------------------------
                           RAxML v8.2.9
--------------------------------------------------------------------------------
"
}

install_muscle()
{
echo "--------------------------------------------------------------------------
                           Downloading muscle v3.8.31
--------------------------------------------------------------------------------
"
conda install --yes -c bioconda muscle=3.8.31 -p $ROOTDIR/thirdParty/miniconda
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
conda install --yes -c bioconda mafft=7.305 -p $ROOTDIR/thirdParty/miniconda
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
conda install --yes -c bioconda paml=4.9 -p $ROOTDIR/thirdParty/miniconda
echo "
--------------------------------------------------------------------------------
                           paml v4.9
--------------------------------------------------------------------------------
"
}



install_perl_Getopt_Long()
{
echo "--------------------------------------------------------------------------
                installing Perl Module Getopt::Long v2.45
--------------------------------------------------------------------------------
"
cpanm Getopt::Long@2.45
echo "
--------------------------------------------------------------------------------
                           Getopt::Long v2.45 installed
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
  if [ -d "$ROOTDIR/thirdParty/miniconda" ]; then
    echo "conda is installed and pointed to right environment"  
  else
    echo "Creating a separate conda enviroment ..."
    conda create --yes -p $ROOTDIR/thirdParty/miniconda
  fi
else
  echo "conda is not found"
  install_miniconda
fi

################################################################################
if ( checkSystemInstallation cpanm )
then
  cpanm_installed_VER=`cpanm -V 2>&1| head -n 1 | grep 'version' | perl -nle 'print $& if m{version \d+\.\d+}'`;
  if  ( echo $cpanm_installed_VER $cpanm_VER | awk '{if($2>=$3) exit 0; else exit 1}' )
  then 
    echo " - found cpanm $cpanm_installed_VER"
  else
  echo "Required version of cpanm was not found"
  install_cpanm
  fi
else 
  echo "cpanm was not found"
  install_cpanm
fi

################################################################################
if ( checkSystemInstallation nucmer )
then
  mummer_installed_VER=`nucmer -v 2>&1| grep 'version' | perl -nle 'print $& if m{version \d+\.\d+}'`;
  if  ( echo $mummer_installed_VER $mummer_VER | awk '{if($2>=$3) exit 0; else exit 1}' )
  then 
    echo " - found nucmer $mummer_installed_VER"
  else
  echo "Required version of nucmer was not found"
  install_mummer
  fi
else 
  echo "nucmer was not found"
  install_mummer
fi
################################################################################

if ( checkSystemInstallation bwa )
then
bwa_installed_VER=`bwa 2>&1| grep 'Version'  | perl -nle 'print $& if m{Version: \d+\.\d+\.\d+}'`;
  if  ( echo $bwa_installed_VER $bwa_VER | awk '{if($2>=$3) exit 0; else exit 1}' )
  then
    echo " - found BWA $bwa_installed_VER"
  else
    install_bwa
  fi
else
  echo "bwa is not found"
  install_bwa
fi
################################################################################

if ( checkSystemInstallation bowtie2 )
then
bowtie2_installed_VER=`bowtie2 --version 2>&1 | grep 'version' | perl -nle 'print $& if m{version \d+\.\d+\.\d+}'`;
  if (echo $bowtie2_installed_VER $bowtie2_VER | awk '{if($2>=$3) exit 0; else exit 1}' )
  then
    echo " - found bowtie2 $bowtie2_installed_VER"
  else
    echo "Required version of bowtie2 $bowtie2_VER was not found"
    install_bowtie2
  fi
else
  echo "bowtie2 is not found"
  install_bowtie2
fi
################################################################################
if ( checkSystemInstallation samtools )
then
  samtools_installed_VER=`samtools 2>&1| grep 'Version'|perl -nle 'print $& if m{Version: \d+\.\d+.\d+}'`;
    if ( echo $samtools_installed_VER $samtools_VER| awk '{if($2>=$3) exit 0; else exit 1}' )
    then
    echo " - found samtools $samtools_installed_VER"
    else
    echo "Required version of samtools $samtools_VER was not found"
    install_samtools
    fi
else
  install_samtools
fi
################################################################################
if ( checkSystemInstallation FastTree )
then
  FastTree_installed_VER=`FastTree 2>&1| grep 'version'|perl -nle 'print $& if m{version \d+\.\d+.\d+}'`;
  if ( echo $FastTree_installed_VER $FastTree_VER | awk '{if($2>=$3) exit 0; else exit 1}' )
  then
    echo " - found FastTree $FastTree_VER"
  else
    echo "Required version of $FastTree_VER was not found"
      install_FastTree
  fi
else
    echo "FastTree was not found"
    install_FastTree
fi

################################################################################
if ( checkSystemInstallation RAxMLHPC )
then
  RAxMLHPC_installed_VER=`raxmlHPC -version 2>&1 | grep 'version' | perl -nle 'print $& if m{version \d+\.\d+\.\d+}'`
  if ( echo $RAxMLHPC_installed_VER $RAxML_VER | awk '{if($2>=$3) exit 0; else exit 1}' )
  then 
    echo " - found RAxML $RAxMLHPC_installed_VER"
  else
    echo "Required version of $FastTree_VER was not found"
      install_RAxML
  fi  
else
  echo "RAxML was not found"
  install_RAxML
fi

################################################################################
if ( checkSystemInstallation muscle )
then
muscle_installed_VER=`muscle -version 2>&1 | grep 'v' | perl -nle 'print $& if m{v\d+\.\d+\.\d+}'`;
  if ( echo $muscle_installed_VER $muscle_VER | awk '{if($2>=$3) exit 0; else exit 1}' )
  then
    echo " - found muscle $muscle_installed_VER"
  else
    echo "Required version of $muscle_VER was not found"
    install_muscle
  fi
else
  echo "muscle was not found"
  install_muscle
fi

################################################################################
if ( checkSystemInstallation mafft )
then
  mafft_installed_VER=`mafft --version 2>&1 | grep 'v' | perl -nle 'print $& if m{v\d+\.\d+}'`;
  if ( echo $mafft_installed_VER $mafft_VER | awk '{if($2>=$3) exit 0; else exit 1}' )
  then 
    echo " - found mafft $mafft_installed_VER"  
  else
  echo "Required version of mafft $mafft_VER was not found"
  install_mafft
  fi
else
  echo "mafft was not found"
  install_mafft
fi
################################################################################
if ( checkSystemInstallation codeml )
then
  paml_installed_VER=`evolver \0 2>&1 | grep 'version' | perl -nle 'print $& if m{version \d+\.\d+}'`;
  if ( echo $paml_installed_VER $paml_VER | awk '{if($2>=$3) exit 0; else exit 1}' )
  then 
    echo " - found paml $paml_installed_VER"
  else 
    echo "Required version of paml $paml_VER was not found"
    install_paml
  fi
else
  echo "paml is not found"
  install_paml
fi

################################################################################
#                                 Perl modules
################################################################################
if ( checkPerlModule Getopt::Long )
then
  echo "Perl Getopt::Long is found"
  perl_Getopt_Long_installed_VER= `cpan -D Getopt::Long 2>&1 | grep "Installed" | perl -nle 'print $& if m{Installed: \d+\.\d+}'`
  if ( echo $perl_Getopt_Long_installed_VER $perl_Getopt_Long_VER | awk '{if($2>=$3) exit 0; else exit 1}')
  then
    echo "- found Perl module Getopt::Long $perl_Getopt_Long_installed_VER"
  else
    echo "Required version of Getopt::Long $perl_Getopt_Long_VER was not found"
    install_perl_Getopt_Long
  fi
else
  echo "Perl Getopt::Long is not found"
  install_perl_Getopt_Long
fi

################################################################################

if ( checkPerlModule Time::HiRes )
then@2.45
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
   unzip $ROOTDIR/ext/opt/HyPhy_v227.zip -d $ROOTDIR/ext/;
   cd $ROOTDIR/ext/hyphy-2.2.7;
   cmake -DINSTALL_PREFIX=$ROOTDIR/thirdParty/miniconda/bin
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
