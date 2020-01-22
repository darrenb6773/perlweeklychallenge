#!perl

my $dividend = 10;
my $divisor = 0;
my $result;

eval {
	$result = $dividend / $divisor;
};

if ($@ =~ m/Illegal division by zero/ ) {
	my $errmsg = $@;
	chomp($errmsg);
	print "Error caught ($errmsg)\n";
} else {
	print "Division result is $result\n";
}
