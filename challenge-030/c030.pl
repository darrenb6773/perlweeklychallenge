#!perl
use strict;
use warnings;

#Task 1
use POSIX;
for my $year (2019..2100) {
  my $date = POSIX::strftime ("%w %Y-%m-%d", 
	              0, 0, 0,  25,  12-1, $year-1900);  
  print "$date is a Sunday Christmas\n" if $date =~ s/^0 //g;
}

#Task 2
my %solutions;
for my $foo (1..10) {
  for my $bar ($foo+1..11-$foo) {  
    my $baz = 12 - $foo - $bar;
	my @sorted = sort ($foo, $bar, $baz);
	my $asoln = join ("\+", @sorted);
	$solutions{$asoln}++;	
  }
}
print "$_ = 12\n" foreach sort keys %solutions;

