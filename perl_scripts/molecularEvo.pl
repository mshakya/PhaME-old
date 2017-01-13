
# input vars
#need to create perl scripts and change the call for them
#  
#  TODO
#
# extractGense
# translateGnese
# alignGenes
# revTranGenes
# core
# paml
# hyphy
#
# TODO 
#
#  add any missing variables that need to be passed to this script. There will be a lot
#
#
my $outdir = shift;
my $project = shift;
my $tbest = shift;
my $pselection = shift;




my $pamldir;
my $ptree;


if ($pselection > 0 ) {
    my $end = 0;
    my $stats_file=$outdir."/$project\_stats.txt";
    my $genedir = $outdir.'/PSgenes';
    if ($pselection == 1 || $pselection == 3 {
        $pamldir = $outdir.'/paml';
        if (!-d $pamldir) {'makdir -p $pamldir';}
        'cp $tbest $pamldir';
        if ($tree ==2 || $tree ==3) {$ptree = $pamldir."/RAxML_bestTree.$project\_cds";}
        if ($tree==1) {$ptree=$pamldir."$outdir./$project\.fasttree";}
        elsif ($tree==0) {print "Need to build a tree before any evolutionary analyses can be performed. \n"; exit;}
    }

    my $gapfile=$outdir."/$project\_gaps.txt";
    $end=PhaME::extractGenes($outdir,$stats_file,$reference,$bindir,"$workdir/working_list.txt",$threads,$gapfile,$genefile,$error,$logfile);
    &print_timeInterval($runtime,"$end\n");

    $end=PhaME::translateGenes($outdir,$bindir,$threads,"translate",$error,$logfile);
    &print_timeInterval($runtime,"$end\n");

    $end=PhaME::alignGenes($outdir,$bindir,$threads,"mafft",$error,$logfile);
    &print_timeInterval($runtime,"$end\n");

    $end=PhaME::revTransGenes($outdir,$bindir,$threads,"pal2nal",$error,$logfile);
    &print_timeInterval($runtime,"$end\n");

    my $core=$genedir."/".$project."_core_genome.cdn";
    $end=PhaME::core($outdir,$bindir,$core,$error,$logfile);
    &print_timeInterval($runtime,"$end\n");

    if ($pselection==1 || $pselection==3){
        PhaME::paml($outdir,$bindir,$ptree,0,"Sites","1,2",$core,$threads,$error,$logfile);
        PhaME::paml($outdir,$bindir,$ptree,2,"BrSites",2,$core,$threads,$error,$logfile);
    }

    if ($pselection==2 || $pselection==3){
        my $rootedtree;
        if ($tree==2||$tree==3){$rootedtree= "$outdir/RAxML_rootedTree.$project\_cds_r";}
        if ($tree==1){$rootedtree="$outdir/$project\_cds_rooted.fasttree";}
        print "$rootedtree\n";
        PhaME::hyphy($outdir,$bindir,$tbest,$rootedtree,$core,$threads,"bsrel",$error,$logfile);
    }
}

