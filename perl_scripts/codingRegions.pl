my $dir=shift;
my $annotation=shift;
my $name=shift;
my $start;
my $end;
my $gap_start=1;
my $gap_end;
my $source_start=1;
my $source_end=0;
my %CDS;
my $line;
my $temp;

my $outfile=$dir."/noncoding.txt";
my $coding=$dir."/CDScoords.txt";

open (OUT,">$outfile");
open (CDS,">$coding");

my $first=1;
my $permutation=0;

open (IN, "$annotation")|| die "$!";
while(<IN>){
   chomp;
      if (/##sequence-region/){
            $permutation=$permutation+$source_end;
             ($line,$temp,$source_start,$source_end)=split " ",$_;
     }
     if (!/^#/){
           my ($name,$source,$method,$start,$stop,$score,$strand,$phase,$field)=split "\t",$_;
           my @group=split ";",$field if ($field);
            if ($method and $method=~/CDS/){
             $start=$start+$permutation;                        
             $stop=$stop+$permutation;

             print CDS "$name\t$start\t$stop\t";
             $CDS{$start}=$stop;
             foreach (@group){if (/product=(.+)/ || /description=(.+)/){print CDS $1;}}
             print CDS "\n";
             }
        }
    }

my $prev=0;
my $last=0;
foreach my $begin (sort{$a<=>$b} keys %CDS){
   my $end=$CDS{$begin};
if ($first){
      if ($begin==1){$gap_start=$end+1;}
      else{
         $gap_end=$begin-1;
       if ($gap_start<$gap_end){print OUT "$name\t$gap_start\t$gap_end\tnoncoding\n";}
     }
    $first = 0;
    }
    else {
    $gap_end = $begin-1;
    if( $gap_start<$gap_end){print OUT "$name\t$gap_start\t$gap_end\tnoncoding\n";}
    }
    if ($begin==$prev){
    $gap_start=$prev-1;
    $gap_end=$prev-1;
    print OUT "$name\t$gap_start\t$gap_end\tnoncoding\n";
    }

    $gap_start=$end+1;
    $prev=$end+2;
    $last=$end;
}

    if ($last < $source_end){
    $gap_start = $last+1;
    print OUT "$name\t$gap_start\t$source_end\tnoncoding\n";
    }








