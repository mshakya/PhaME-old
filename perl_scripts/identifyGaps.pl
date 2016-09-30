my $dir=shift;
my $list=shift;
my $name=shift;
my $type=shift;
my $project=shift;
my $gapdir=$dir.'/gaps';
my $repeatdir=$dir.'/stats';
my %query;
my $line=0;
my $all_gapfile;
my $gap_start;
my $gap_end;

if ($type=~/map/){$all_gapfile="$dir\/$project\_mapping_gaps.txt";}
elsif ($type=~/snp/){$all_gapfile="$dir\/$project\_all_gaps.txt";}
open (GAP,">$all_gapfile")||die "$!";

open (LIST,"$list")||die "$!";
while (<LIST>){
    chomp;
    $query{$_}++;
}
close LIST;

opendir(DIR,"$gapdir");
while (my $gaps= readdir(DIR)){
    if ($gaps=~ /^$name\_norepeats\_(.+)\_norepeats\.gaps/ || $gaps=~ /^$name\_(.+_contig)s?\.gaps/ ||$gaps=~ /^$name\_(.+)\.gaps/ ){
          if (exists $query{$1}){
            $line=0;
            my $gapfile= "$gapdir/$gaps";
            open (IN,$gapfile)|| die "$!";
            #print "Nucmer Gaps\n";
            while (<IN>){$line++; print GAP "$_";}
            close IN;
            if ($line ==0){print "Empty File: $gapfile\n";$line=0;}
        }
    }
    if ($type=~/snp/){
        if ($gaps=~ /^$name\_(.+)\_$name(\_\d+\_\d+)?\.gaps$/){
            my $query=$1;
            my @read_types=("_pread","_sread","_read");
            foreach my $type(@read_types){
                my $tmp= $query.$type;
                if (exists $query{$tmp}){
                    my $gap_file= "$gapdir/$gaps";
                    $line=0;
                    open (IN,$gap_file)|| die "$!";

                    while (<IN>){
                        chomp;
                        $line++;
                        next if (/Start\s+End\s+Length.+/);
                        my ($start,$end,$length,$ref)= split "\t",$_;
                        if ($ref=~ /$name\_(\d+)\_(\d+)$/){
                            $gap_start=$start+$1-1;
                            $gap_end=$1+$end-1;
                        }
                        else{
                            $gap_start=$start;
                            $gap_end=$end;
                        }
                        print GAP "$name\t$gap_start\t$gap_end\t$length\t${query}$type\n";
                    }
                    close IN;
                    if ($line == 1){`rm $gap_file`; $line=0;}
                }
         }
      }
   }
 }
closedir DIR;

opendir(REPEAT,"$repeatdir");
while (my $repeats= readdir(REPEAT)){
    if ($repeats=~ /$name\_repeat_coords\.txt/){
        my $repeatfile= "$repeatdir/$repeats";
        open (IN,$repeatfile)|| die "$!";

        while (<IN>){
            chomp;
            my ($ref,$temp,$start,$end,$length)= split "\t",$_;
            print GAP "$ref\t$start\t$end\t$length\tREPEATS\n";
        }
        close IN;
    }
}
closedir REPEAT;
print $all_gapfile;

