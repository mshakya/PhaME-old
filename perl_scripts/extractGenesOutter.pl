my $dir = shift;
my $stat=shift;
my $file=shift;
my $bindir=shift;
my $list=shift;
my $thread=shift;
my $gapfile=shift;
my $genefile=shift;
my $error=shift;
my $log=shift;
my $genedir=$dir.'/PSgenes';


print "\n";
my $extract = "$bindir../ext/bin/extractGenes.pl -d $dir -t $thread -l $list -s $stat -f $file -p $gapfile -g $genefile 2>>$error >>$log\n\n";

print $extract;
if (system ($extract)){die "Error running $extract.\n";}

opendir (DIR,"$genedir") ||die "$!";
OUTER:while (my $files= readdir(DIR)){
    next if ($files=~/^..?$/);
    if ($files=~ /.+\.fna$/){
        my $file= $genedir.'/'.$files;
        open (IN,"$file")|| die"$!";
        while (<IN>){
            if (!/^>/){
                if (!/^ATG/){
                    print "$file\n";
                    `rm $file`;
                    next OUTER;
                }
            }
        }
        close IN;
    }
}

print ("Genes with SNPs in PSgenes Directory \n ");
