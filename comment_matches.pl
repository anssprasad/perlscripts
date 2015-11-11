#! /usr/intel/bin/perl

use Getopt::Long qw(GetOptions);

my $sep;
my $field_num;
my $filename;
my %hasht;
my $debug;

if($#ARGV eq -1)
{
print ("$#ARGV Usage example:perl comment_matches.pl -file see -sep \" \" -n 7 -filelist <> -debug \n");
}
GetOptions (
            'sep=s' => \$sep,
            'file=s' => \$filename,
            'filelist=s' => \$filelist,
            'match_field=i' => \$match_field,
            'debug=i' => \$debug,
            'output=s' => \$outputfile,
            'n=i' => \$field_num
           ) ; #or 
#die ("Usage: perl extractn.pl -file <filename to parse> -sep <separator> -n <field number>\n");

if($debug) { print ("Parsing file $filename using serparator $sep and printing field $field_num\n")};

open(my $FH, "<", $filename) or die ("cannot open file $filename: $! \n");
open(my $FLH, "<", $filelist) or die ("cannot open file $filelist: $! \n");
#open(my $MFH, "<", $match_file) or die ("cannot open file $match_file: $! \n");
#open(my $OFH, ">", $outputfile) or die ("cannot open file $outputfile: $! \n");

# This is the file read to create a hash with a string as key
while(<$FH>) {
  $line = $_;
  @line_arr=split("$sep", $line);
  $signal = $line_arr[$field_num];
  $signal =~ s/^\s+//;
  $signal =~ s/\s+$//;
  push @signals, $signal;
  if($debug) { print "see $signal\n";}
}

print "List of files\n";
while(<$FLH>) {
  $line=$_;
  chomp($line);
  if(-e $line) {
    push @files, $line;
  } else {
    print "$line does not exist\n";
  } 
  print "$line\n";
}
my $temp="temp";
#search each file to match the string and comment the line if it is a match
foreach $file(@files) {
  print "working on $file\n";
  open(my $FLL, "+<", $file) or die ("cannot open file $file: $! \n");
  open(my $TMP, ">", $temp) or die ("cannot open file $file: $! \n");
  while(<$FLL>) {
    $line = $_;
    chomp($line);
    $signal_found =0;
    foreach $signal (@signals){
      #print "Searching for signal $signal\n";
      ($match) = $line =~ m/$signal/; # this is how you can figure out what is matching
      #print "match $match\n";
      if($line =~ m/$signal/){
        @line_array = split("", $line);
        if($line_array[0] eq "/") {
        } else {
          $line =~ s/^(.)/\/\/\1/; # add // at beginning of line if it is not already a comment
        }
        print "after: $line\n";
        print $TMP "$line\n";
        $signal_found =1;
        last;
      } 
    }
    if($signal_found == 0){ print $TMP "$line\n"};
  }
  close $TMP;
  $cmd = "cp $temp $file";
  print "$cmd\n";
  system($cmd);
  print $?;
}
