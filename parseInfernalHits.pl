#!usr/bin/perl -w
#
#This script parses the hits from infernal and returns a 
#tab delimited file with the sequence id, the matching rfam,
#the rfam description, the Evalue,
#
#structure of infernal table:
##target name         accession query name           accession mdl mdl from   mdl to seq from   seq to strand trunc pass   gc  bias  score   E-value inc description of target
##------------------- --------- -------------------- --------- --- -------- -------- -------- -------- ------ ----- ---- ---- ----- ------ --------- --- ---------------------
#DdR11                RF01561   FUME0IW02QWLFT_105   -         hmm       16       65      211      260      +     -    6 0.28   0.2   13.5      0.14 ?   D. discoideum snoRNA DdR11
#
use strict;
use Getopt::Long;
use diagnostics;

our $debug = 0;
our $debug2 = 0;

my $infile = "L4-unclassified_Infernal_Rfam_all.txt.gz";
my $outfile = "L4-Rfam-all_topHits.txt";
my $cutoff = 100;
GetOptions(
    "in=s"  =>  \$infile,
    "debug" =>  \$debug,
    "out=s" => \$outfile,
    "cutoff=s" => \$cutoff,
);


open IN, "zmore $infile |" || die "cannot open $infile, $!\n";

## make a sequence hash
my $sh = {};
my $head = 1;
while( my $line = <IN>){
    print $line if ($debug);
    chomp $line;
    my $addEntry = 0 ;
    if ( $line =~ m/^#/ || $head ){
        print "comment line\n" if ($debug ) ;
        $head = 0;
        next;
    } else {
        my @flds = split(' ' , $line);
        if ($debug) {
            my $i = 0;
            for my $field (@flds){
               print $i."\t".$field."\n";
               $i++;
            }
            if(defined($sh->{$flds[2]}->{E})){
                print "old score = ".$sh->{$flds[2]}->{E}."\n";
            } else {
                print "no old score\n";
            }
            print "new score = ".$flds[15]."\n";
    
        }
        if ((!defined($sh->{$flds[2]}->{E}) || $sh->{$flds[2]}->{E} > $flds[15]) && $flds[15] <= $cutoff ) {
            print "adding entry to hash\n" if ($debug);
            $sh->{$flds[2]}->{E} = $flds[15];
            $sh->{$flds[2]}->{target} = $flds[0];
            $sh->{$flds[2]}->{access} = $flds[1];
            my $desc;
            $desc = $flds[17];
            for( my $c = 18 ; $c < @flds ; $c++){
                $desc .= " ".$flds[$c];
            }
            print "$desc\n" if ($debug);
            $sh->{$flds[2]}->{desc} = $desc;
        }
    }
}
close(IN);

open OUT, "> $outfile" || die "cannot open $outfile, $!\n";

my $header = "seq\trfam\taccession\tE-value\tdescription\n";

print OUT $header; 

my @seqs = sort(keys(%$sh));

for my $seq (@seqs){
    if ( defined($sh->{$seq}->{E} )){
        my $row = $seq."\t";
        $row .= $sh->{$seq}->{target}."\t";
        $row .= $sh->{$seq}->{access}."\t";
        $row .= $sh->{$seq}->{E}."\t";
        $row .= $sh->{$seq}->{desc}."\n";
        print $row if ($debug2);
        print OUT $row;
    }
}

close(OUT);
system("gzip $outfile");
