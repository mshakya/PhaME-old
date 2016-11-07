my $indir=shift;
my $bindir=shift;
my $list=shift;
my $thread=shift;
my $name=shift;
my $error=shift;
my $log=shift;
my $outdir=$indir."/results";
my $reference= $outdir.'/temp/'.$name.'.fna';
my $type;

if(!-e $reference || -z $reference){ $reference = $indir.'/files/'.$name.'.fna';}
print "\n";
my $map="$bindir../ext/bin/runReadsMapping.pl -r $reference -q $indir -d $outdir -t $thread -l $list -a bowtie 2>>$error >> $log\n\n";
print $map;
if (system ($map)){die "Error running $map.\n";}

opendir (CLEAN, "$outdir");
while (my $file= readdir(CLEAN)){
   if ($file=~/.+\.vcf$/){
         my $vcf_file=$outdir.'/'.$file;
        `mv $vcf_file $outdir/snps`;
        print "Moved $file to the snps directory\n";
    }
}
closedir CLEAN;
print ("Read Mapping complete");
