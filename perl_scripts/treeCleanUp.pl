my $refdir = shift;
my $tree = shift;
my $outdir = shift;



my $tinfo=$refdir."/RAxML_info.$project\_all";
my $tlog=$refdir."/RAxML_log.$project\_all";
my $tparsimony=$refdir."/RAxML_parsimonyTree.$project\_all";
my $tresult=$refdir."/RAxML_result.$project\_all";
my $tbest=$refdir."/RAxML_bestTree.$project\_all";
if (-e $tinfo){`mv $tinfo $outdir/`;}
if (-e $tlog){`mv $tlog $outdir/`;}
if (-e $tparsimony){`mv $tparsimony $outdir/`;}
if (-e $tresult){`mv $tresult $outdir/`;}
if (-e $tbest){`mv $tbest $outdir/`;}
if ($tree==2||$tree==3){$tbest=$outdir."/RAxML_bestTree.$project\_cds";}
if ($tree==1){$tbest=$outdir."/$project\.fasttree";}


print " Tree clean up comleted. Moved files to output directory \n ";
