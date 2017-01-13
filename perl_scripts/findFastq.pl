######  open workdir/files - iterate through

my $workdir = shift;
my $filedir = "$workdir/files";

opendir(DIR, $filedir);
while(my $files = readdir(DIR)) {
      if($files=~ /.+\.f{1}a?s?t?q$/ && $files!~ /.+\.f{1}n|s?a?s?t?a$/ && $files!~ /\.contigs?/){ #find fastq files only
            my $fastq=$refdir.'/'.$files;
            print "$qname\n";
            my $read_list_name;
            if ($qname=~/(.+)[_.]R?[12]$/){
                if ($reads==2){
                    $read_list_name=$1.'_pread';

                    }
                if ($reads==1 && !exists $read_list{"$1_pread"}){
                    $read_list_name=$1.'_sread';
                    }
                if ($reads ==1 && !exists $read_list{"$1_pread"}){
                    $read_list_name=$1.'_sread';
                    }
                if ($reads==3){
                    delete $read_list{"$1_sread"};
                    $read_list_name=$1.'_read';
                    $read_list_name=$1.'_pread' if ( ! -e "$workdir/$1.fastq" && ! -e "$workdir/$1.fq");
                    }

                $read_list{$read_list_name}++;
                }
                else{
                    next if ($reads==2 || exists $read_list{"${qname}_read"});
                    $read_list_name=$qname.'_sread';
                    $read_list{$read_list_name}++;
                    } 
    }
}

closedir DIR;

open (READ, ">$workdir/reads_list.txt")||die "$!";  # put stuff in reads_list.txt

foreach my $names(keys %read_list){print ALL "$names\n";}
foreach my $names(keys %read_list){print READ "$names\n";}


