#!/usr/bin/perl -w

######################################################
# Written by Sanaa Ahmed
# Nov. 30, 2012

# Given a directory containing fasta files, runs nucmer
#  Runs nucmer only on files ending in .fna
#  Runs nucmer on all against all

######################################################

# print STDOUT "EXECUTING runNUCmer.pl";
# print "testing execution of runNUCmer.pl";

use strict;
use warnings;
use FindBin qw($RealBin);
use Getopt::Long;
use File::Basename;
use Parallel::ForkManager;

# set up environments
$ENV{PATH} = "$RealBin:$RealBin/../ext/bin:../perl_scripts:$ENV{PATH}";

my $breaklen        = 200;
my $mincluster      = 65;
my $diagfactor      = 0.12;
my $maxgap          = 90;
my $minmatch        = 20;
my $identity        = 0;
my $gap_cutoff      = 0;
my $repeat_identity = 97;
my $len_cutoff      = 100;
my ( $query_dir, $thread, $list, $code );
my @query;
my $outdir;

# my $outdir = `pwd`;
# $outdir =~ s/\n//;
my $options = "--maxmatch ";

GetOptions(
    'q|querydir=s' => \$query_dir,
    'd|outdir=s'   => \$outdir,
    't|thread=i'   => \$thread,
    'l|list=s'     => \$list,
    'c|code=s'     => \$code,
    'h|help'       => sub { usage() }
);

&usage("Missing input files.") unless ($query_dir);

my $max_thread
    = ( $^O =~ /darwin/ )
    ? `sysctl hw.ncpu | awk '{print \$2}'`
    : `grep -c ^processor /proc/cpuinfo`;
if ( $thread < 1 || $thread > $max_thread ) {
    die("-thread value must be between 1 and $max_thread.\n");
}

# create folders within output directory
if ( !-e $outdir ) {
    `mkdir -p $outdir $outdir/gaps $outdir/snps $outdir/delta $outdir/stats $outdir/temp $outdir/filters`;
}
elsif ( !-e "$outdir/gaps" ) {
    `mkdir -p "$outdir/gaps"`;
}
elsif ( !-e "$outdir/snps" ) {
    `mkdir -p "$outdir/snps"`;
}
elsif ( !-e "$outdir/delta" ) {
    `mkdir -p "$outdir/delta"`;
}
elsif ( !-e "$outdir/stats" ) {
    `mkdir -p "$outdir/stats"`;
}
elsif ( !-e "$outdir/temp" ) {
    `mkdir -p "$outdir/temp"`;
}
elsif ( !-e "$outdir/filters" ) {
    `mkdir -p "$outdir/filters"`;
}
# Options to use if input genomes are from viruses
if ( $code !~ /virus/ ) {
    my $options
        = "--maxmatch -b $breaklen -c $mincluster -d $diagfactor -g $maxgap -l $minmatch ";
}

$gap_cutoff = "-l $gap_cutoff";
$identity   = "-i $identity";

my $snp_indel;
my $snp_n;
my $indel_n;
my $gaps;
my $ref_gaps;
my $query_gaps;

#$ENV{PATH}= "$bindir:/usr/local/bin:/usr/bin:/bin:/opt/apps/bin";

#MAIN
print "$query_dir\n";
read_directory( $query_dir, $list );
run_self_nucmer(@query);
run_nucmer(@query);
cleanup();
################################################################################
sub read_directory {
    my $dir  = shift;
    my $list = shift;
    my $query_file;
    my %queries;

    # if ( $dir =~ /.+\/$/ ) { my $temp = chop($dir); }

    # $dir = $dir . '/files';
    # print "$dir\n";

    open( my $FH, $list );
    while (<$FH>) {
        chomp;
        $queries{$_}++;
    }
    close $FH;

    opendir( PARENT, $dir );
    while ( my $files = readdir(PARENT) ) {
        next if ( $files =~ /^..?$/ );
        if ( $files =~ /(.+)\.fna$/ ) {
            next if ( $files =~ /contig/ );
            if ( exists $queries{$1} ) {
                $query_file = $dir . '/' . $files;
                push( @query, $query_file );
            }
        }
    }
    closedir(PARENT);
}
################################################################################
sub run_self_nucmer {
    my $ident      = 95;
    my $len_cutoff = 75;

    my $pm = new Parallel::ForkManager($thread);
    $pm->run_on_finish(
        sub {
            my ( $pid, $exit_code, $ident, $exit_signal, $core_dump ) = @_;
        }
    );

    foreach my $reference (@query) {
        $pm->start and next;
        my ( $name, $path, $suffix ) = fileparse( "$reference", qr/\.[^.]*/ );
        my $coords = $outdir . '/' . $name . '_repeat_coords.txt';
        my $stat   = $outdir . '/' . $name . '_repeat_stats.txt';
        my $fasta  = $outdir . '/' . $name . '_norepeats.fna';

        my $command
            = "get_repeat_coords.pl -l $len_cutoff -i $repeat_identity -o $coords -s $stat $reference";
        if ( system($command) ) { die "Error running $command.\n"; }
        my $remove_repeats
            = "removeRepeats.pl -f $reference -c $coords -o $fasta";
        if ( system($remove_repeats) ) {
            die "Error running $remove_repeats.\n";
        }
        $pm->finish(0);
    }
    $pm->wait_all_children;

    print "\nRepeat coords for all references found.\n";
    print "Self-NUCmer complete\n\n";
}
################################################################################
sub run_nucmer {
    my $iteration = combo( 2, @query );
    my $pm = new Parallel::ForkManager($thread);

    $pm->run_on_finish(
        sub {
            my ( $pid, $exit_code, $ident, $exit_signal, $core_dump ) = @_;
        }
    );

    while ( my @combo = $iteration->() ) {
        $pm->start(@combo) and next;
        my %hash;
        my ( $first_name, $first_path, $first_suffix )
            = fileparse( "$combo[0]", qr/\.[^.]*/ );
        my ( $second_name, $second_path, $second_suffix )
            = fileparse( "$combo[1]", qr/\.[^.]*/ );
        my $reference = "$first_path$first_name$first_suffix";
        my $query     = "$second_path$second_name$second_suffix";
        $first_name =~ s/\.fna//;
        $second_name =~ s/\.fna//;
        my $prefix1 = $first_name . '_' . $second_name;
        my $prefix2 = $second_name . '_' . $first_name;

        my $first_fasta  = $outdir . '/' . $first_name . '_norepeats.fna';
        my $second_fasta = $outdir . '/' . $second_name . '_norepeats.fna';
################################################################################
        print "##############################################################\n";
        print "# Running first instance of nucmer on $prefix1\n";
        print "#############################################################\n\n";
        my $nucmer_command1
            = "nucmer $options -p $prefix1 $first_fasta $second_fasta  2>/dev/null";

        if ( system($nucmer_command1) ) {
            die "Error running nucmer_command1 $nucmer_command1.\n";
        }
        else {
            my $delta_file = join( '.', $prefix1, "delta" );
            my $dest_delta = join( '/', $outdir, "delta", $delta_file );
            `mv $delta_file $dest_delta`;
        }
################################################################################
        print "#############################################################\n";
        print "# Running first instance of filter (delta-filter) on $prefix1\n";
        print "#############################################################\n\n";
        my $filter_command1
            = "delta-filter -1 $identity $outdir/delta/$prefix1.delta > $outdir/filters/$prefix1.snpfilter";

        if ( system($filter_command1) ) {
            die "Error running filter_command1 $filter_command1.\n";
        }
################################################################################
        print "#############################################################\n";
        print "# Running first instance of snp finding (show-snps) on $prefix1\n";
        print "############################################################\n\n";
        my $snp_command1
            = "show-snps -CT $outdir/filters/$prefix1.snpfilter > $outdir/snps/$prefix1.snps";
        if ( system($snp_command1) ) {
            die "Error running snp_command1 $snp_command1.\n";
        }
        $snp_indel = `SNP_INDEL_count.pl $outdir/$prefix1.snps`;
        $snp_indel =~ s/\n//;
        ( $snp_n, $indel_n ) = split /\t/, $snp_indel;
################################################################################
        print "#############################################################\n";
        print "# Running filter_command2 (delta-filter) on $prefix1\n";
        print "############################################################\n\n";
        my $filter_command2
            = "delta-filter -1 $identity $outdir/delta/$prefix1.delta > $outdir/filters/$prefix1.gapfilter";
        if ( system($filter_command2) ) {
            die "Error running filter_command2 $filter_command2.\n";
        }
################################################################################
        print "#############################################################\n";
        print "# Running coords command (show-coords) on $prefix1\n";
        print "############################################################\n\n";
        my $coords_command1
            = "show-coords -clTr $outdir/filters/$prefix1.gapfilter > $outdir/$prefix1.coords";
        if ( system($coords_command1) ) {
            die "Error running coords_command1 $coords_command1.\n";
        }
################################################################################
        print "#############################################################\n";
        print "# Running gaps (parseGapsNUCmer.pl) command on $prefix1\n";
        print "#############################################################\n\n";
        my $gaps1
            = "parseGapsNUCmer.pl $gap_cutoff $outdir/$prefix1.coords 2>/dev/null";
        # ( $ref_gaps, $query_gaps, undef ) = split /\n/, $gaps1;
        # my $gaps_file1 = join('.', $prefix1, 'gaps');
        # print "$gaps_file1\n";

        if ( system($gaps1) ) {
            die "Error running gaps1 $gaps1.\n";
        }
        my $gaps_file1 = join('.', $prefix1, 'gaps');
        `mv $gaps_file1 $outdir/gaps`;

################################################################################
        print "#############################################################\n";
        print "Running nucmer on $prefix2\n";
        print "#############################################################\n\n";
        my $nucmer_command2
            = "nucmer $options -p $prefix2 $second_fasta $first_fasta  2>/dev/null";
        if ( system($nucmer_command2) ) {
            die "Error running nucmer_command2 $nucmer_command2.\n";
        }
        else {
            my $delta_file = join( '.', $prefix2, "delta" );
            my $dest_delta = join( '/', $outdir, "delta", $delta_file );
            `mv $delta_file $dest_delta`;
        }
################################################################################
        print "#############################################################\n";
        print "# Running delta-filter command on $prefix2\n";
        print "#############################################################\n\n";
        my $filter_command3
            = "delta-filter -1 $identity $outdir/delta/$prefix2.delta > $outdir/filters/$prefix2.snpfilter";
        if ( system($filter_command3) ) {
            die "Error running filter_command3 $filter_command3.\n";
        }
################################################################################
        print "#############################################################\n";
        print "# Running snp (show-snps) on $prefix2\n";
        print "#############################################################\n\n";
        my $snp_command2
            = "show-snps -CT $outdir/filters/$prefix2.snpfilter > $outdir/snps/$prefix2.snps";
        if ( system($snp_command2) ) {
            die "Error running snp_command2 $snp_command2.\n";
        }
        $snp_indel = `SNP_INDEL_count.pl $outdir/snps/$prefix2.snps`;
        $snp_indel =~ s/\n//;
        ( $snp_n, $indel_n ) = split /\t/, $snp_indel;
################################################################################
        print "#############################################################\n";
        print "# Running delta-filter command on $prefix2\n";
        print "#############################################################\n\n";

        my $filter_command4
            = "delta-filter $identity $outdir/delta/$prefix2.delta > $outdir/filters/$prefix2.gapfilter";
        if ( system($filter_command4) ) {
            die "Error running filter_command4 $filter_command4.\n";
        }
################################################################################
        print "#############################################################\n";
        print "# Running (show-coords) command on $prefix2\n";
        print "#############################################################\n\n";

        my $coords_command2
            = "show-coords -clTr $outdir/filters/$prefix2.gapfilter > $outdir/stats/$prefix2.coords";
        if ( system($coords_command2) ) {
            die "Error running coords_command2 $coords_command2.\n";
        }
################################################################################
        print "#############################################################\n";
        print "# Running gaps (parseGapsNUCmer) command on $prefix2\n";
        print "#############################################################\n\n";

        my $gaps2
            = "parseGapsNUCmer.pl $gap_cutoff $outdir/stats/$prefix2.coords 2>/dev/null";
        if ( system($gaps2) ) {
            die "Error running gaps1 $gaps1.\n";
        }
        my $gaps_file2 = join('.', $prefix2, 'gaps');
        `mv $gaps_file2 $outdir/gaps/`;
################################################################################
        print "#############################################################\n";
        print "# Checking (checkNUCmer.pl) alignment proportions\n";
        print "#############################################################\n\n";

        my $check
            = `checkNUCmer.pl -i $outdir/gaps/$first_name\_$second_name.gaps -r $reference`;
        if ( $check == 1 ) {
            print "$second_name aligned < 25% of the $first_name genome\n";
        }

        $check
            = `checkNUCmer.pl -i $outdir/gaps/$second_name\_$first_name.gaps -r $query`;
        if ( $check == 1 ) {
            print "$first_name aligned < 25% of the $second_name genome\n";
        }
        # removing all gaps file
        #TODO: Need to check why its being written in the first place
        `rm *.gaps`;

        ( $ref_gaps, $query_gaps, undef ) = split /\n/, $gaps2;

        $pm->finish(0);
    }
    $pm->wait_all_children;

    print "NUCmer on all reference genomes complete.\n";
}
################################################################################
sub combo {
    my $by = shift;
    return sub { () }
        if !$by || $by =~ /\D/ || @_ < $by;
    my @list = @_;

    my @position = ( 0 .. $by - 2, $by - 2 );
    my @stop     = @list - $by .. $#list;
    my $end_pos  = $#position;
    my $done     = undef;

    return sub {
        return () if $done;
        my $cur = $end_pos;
        {
            if ( ++$position[$cur] > $stop[$cur] ) {
                $position[ --$cur ]++;
                redo if $position[$cur] > $stop[$cur];
                my $new_pos = $position[$cur];
                @position[ $cur .. $end_pos ] = $new_pos .. $new_pos + $by;
            }
        }
        $done = 1 if $position[0] == $stop[0];
        return @list[@position];
        }
}
################################################################################
sub cleanup {

    #if (-e "$outdir/*.coords"){`rm $outdir/*.coords`};
    if ( -e "$outdir/*.mgaps" ) { unlink "$outdir/*.mgaps" }
    if ( -e "$outdir/*.ntref" ) { unlink "$outdir/*.ntref" }
    `cat $outdir/*_repeat_stats.txt > $outdir/repeat_stats.txt`;
    `mv $outdir/*_stats.txt $outdir/stats`;
    `mv $outdir/*_coords.txt $outdir/stats`;
    `mv $outdir/*.coords $outdir/stats`;
    `mv $outdir/*norepeats.fna $outdir/temp`;
}
################################################################################
sub usage {
    my $msg = shift;
    my $short_usage
        = "perl $0 -q <query_dir> -d <output_directory> -t <# threads> -l <file containing list of all genomes to run nucmer on> -c <code>";
    ($msg)
        ? print
        "\n $msg\n\n $short_usage\n\n Option -h to see full usage \n\n"
        : print <<"END";
   
   Usage: $short_usage
   Input: 
      -q working directory 

      -d output directory where all the nucmer generated files will be written

      -t number of threads to be usind for running nucmer, defaulat=1

      -l A text file with name of all fasta files that will be aligned against each other
      
      -c Superkingdom of respected genomes, important for nucmer parameters.

END

    # Usage
    exit(1);
}
