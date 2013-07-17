#!usr/bin/perl -w

use strict;
use Getopt::Long;
use File::Basename;
use File::Glob;
use File::Copy;

our $verbose = 1 ;

my $fasta;
my $num = 1000;
my $noSplit;

GetOptions ( "fasta=s" => \$fasta,
            "n=i" =>        \$num,
            "verbose" =>  \$verbose,
            "v"       =>  \$verbose,
            "noSplit" =>  \$noSplit,
) or die( "Error in command line arguments\n" );

if ( !$fasta ) {
    die "You must specify an input fasta file with the --fasta parameter\n";
}

my($filename, $directories, $suffix) = fileparse($fasta,  qr/\.[^.]*/);
print "suffix\t$suffix\n" if $verbose;
print "filename\t$filename\n" if $verbose;
system("pyfasta split -n $num $fasta") unless($noSplit);

my $fastaPat = $filename.".*".$suffix;

print "fastaPattern\t$fastaPat\n" if($verbose);

my @fastas = glob $fastaPat;

my $i = 1;

for my $fa (@fastas){
    print $fa."\n" if ($verbose);
    my $nName = "${filename}.${i}${suffix}";
    print $nName."\n" if ($verbose);
    move($fa , $nName);
    $i++;
}





