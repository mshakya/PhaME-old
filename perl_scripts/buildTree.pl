


my $bindir=shift;
my $outdir=shift;
my $thread=shift;
my $tree=shift;
my $name=shift;
my $error=shift;
my $log=shift;


if ($tree==1||$tree==3){
    print "\n";
    my $fasttree="export OMP_NUM_THREADS=$thread; FastTreeMP -nt -gtr < $outdir/$name\_snp_alignment.fna > $outdir/$name\.fasttree 2 >>$error\n";
    print $fasttree;
    if (system ($fasttree)){die "Error running $fasttree.\n";}

    my $rooted_tree_cmd= "raxmlHPC-PTHREADS -T $thread -m GTRGAMMAI -f I -t $outdir/$name.fasttree -w $outdir -n $name 2>>$error >> $log\n\n";
    eval{ system($rooted_tree_cmd);};
    system("mv $outdir/RAxML_rootedTree.$name $outdir/${name}_rooted.fasttree") if ( -e "$outdir/RAxML_rootedTree.$name");
    `rm $outdir/RAxML_info.$name`;
}

if ($tree==2||$tree==3){
    print "\n";
    my $raxml="$bindir../ext/bin/raxmlHPC-PTHREADS -p 10 -T $thread -m GTRGAMMAI -s $outdir/$name\_snp_alignment.fna -w $outdir -n $name 2>>$error >> $log\n\n";
    print $raxml;
    if (system ($raxml)){die "Error running $raxml.\n";}
    my $rooted_tree_cmd= "$bindir../ext/bin/raxmlHPC-PTHREADS -T $thread -m GTRGAMMAI -f I -t $outdir/RAxML_bestTree.$name -w $outdir -n $name\_r 2>>$error >> $log\n\n";
    print $rooted_tree_cmd;
    if (system ($rooted_tree_cmd)){die "Error running $rooted_tree_cmd.\n";}
}


open (OUT, ">>$log");
print OUT "Tree phylogeny complete.\n";
close OUT;


#if ($tree==1){return ("Fasttree phylogeny complete");}
#if ($tree==2){return ("RAxML phylogeny complete");}
#if ($tree==3){return ("Phylogeny complete");}

