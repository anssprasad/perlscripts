#! /usr/bin/perl

use Getopt::Long qw(GetOptions);

my $sep;
my $field_num;
my $filename;

GetOptions (
            'sep=s' => \$sep,
            'file=s' => \$filename,
            'n=i' => \$field_num
           ) or 
die ("Usage: perl extractn.pl -file <filename to parse> -sep <separator> -n <field number>\n");

print ("Parsing file $filename using serparator $sep and printing field $field_num\n");

open(my $FH, "<", $filename) or die ("cannot open file $filename: $! \n");

while(<$FH>) {
  $line = $_;
  @line_arr=split($sep, $line);
  print "$line_arr[$field_num]\n";
}
