my $bindir=shift;
my $outdir=shift;
my $thread=shift;
my $tree=shift;
my $name=shift;
my $bootstrap=shift;
my $error=shift;
my $log=shift;



if ($tree==1){
    my $bootTrees="$bindir../ext/bin/raxmlHPC-PTHREADS -p 10 -T $thread -m GTRGAMMAI -b 10000 -t $outdir/$name\.fasttree -s $outdir/$name\_snp_alignment.fna -w $outdir -N $bootstrap -n $name\_b -k 2>>$error >> $log\n\n";
    print $bootTrees;
    if (system ($bootTrees)){die "Error running $bootTrees.\n";}

    my $bestTree="$bindir../ext/bin/raxmlHPC-PTHREADS -p 10 -T $thread -f b -m GTRGAMMAI -t $outdir/$name\.fasttree -s $outdir/$name\_snp_alignment.fna -z $outdir/RAxML_bootstrap.$name\_b -w $outdir -n $name\_best 2>>$error >> $log\n\n";
    print $bestTree;
    if (system ($bestTree)){die "Error running $bestTree.\n";}
 }  

    if ($tree > 1){
         my $bootTrees="$bindir../ext/bin/raxmlHPC-PTHREADS -p 10 -T $thread -m GTRGAMMAI -b 10000 -t $outdir/RAxML_bestTree.$name -s $outdir/$name\_snp_alignment.fna -w $outdir -N $bootstrap -n $name\_b -k 2>>$error >> $log\n\n";
        print $bootTrees;
        if (system ($bootTrees)){die "Error running $bootTrees.\n";}
        my $bestTree="$bindir../ext/bin/raxmlHPC-PTHREADS -p 10 -T $thread -f b -m GTRGAMMAI -t $outdir/RAxML_bestTree.$name -s $outdir/$name\_snp_alignment.fna -z $outdir/RAxML_bootstrap.$name\_b -w $outdir -n $name\_best 2>>$error >> $log\n\n";
        print $bestTree;
        if (system ($bestTree)){die "Error running $bestTree.\n";}
}

print "Bootstrap complete";
    
