I was tempted by this weeks challenge, and it's 'goal seeking' concept.
Seemed just the right kind of task for an 'old school' language.
Cracked out my rusty Prolog skills, installed SWI-Prolog and got to know Prolog a lot better.

I think this will be my only (unsupported) attempt for this weeks challenge, 
as I've got a lot of new employment opportunites to research for and hopefully to apply to.

[The Tweet](https://twitter.com/PerlWChallenge/status/1219114965438611458) that started it all 

D.


# Rundown of the Perl attempt
### Standard header, you can't really afford not to use strict
    #!/bin/perl
    use strict;
   
### Prep for the numberlist and possible symbols to put in front of each digit
    my $numlist = $ARGV[1]||'123456789'; # Command line overide, default to 1-9
    my @numarray = split('',$numlist);
    
    my @symbols =( ",", '', ",-"); # Split, Join, Negate
    
### Prep the combation iterator so that the first digit isn't unnecessarily split (and yield a duplicate solution)
    my @combination = ( 1,(0) x 8); # Skip over the join option for the first digit 
    my $solutions_found=0;


    while(1) {
    	#warn join(",", @combination);
    	my $blend='';

### Compose the solution from the combination iterator mapping onto their symbols
       for my $blend_dig (0..8) {
    		$blend .= $symbols[$combination[$blend_dig]].$numarray[$blend_dig];
    	}
    	
### Split the blend on commas, then add up the result
      my $sum =0;
    	my @blend_nums = split(',',$blend);
    	$sum += $_ foreach @blend_nums;
    	my $sumstr = join ('+',@blend_nums);
    	$sumstr =~ s/\+-/-/g; # Remove + before -
    	# warn "$sumstr == $sum";
    	# die if $trial > 10;
### next is used to skip to only solutions with thhe right total
      next unless $sum == 100;
    	$solutions_found++;
    	print "$sumstr = $sum\n";
    	}
### Continue allows a clean loop, a next jumps here instead of the loop top
    continue {
    	my $next_rc = next_combination();
    	last if $next_rc < 0; # Overflow
    }
    
    print "$solutions_found solutions found\n";
    
### next_combination rolls the symbol indexes, starting at the last digit, going left
    sub next_combination() {
    	# warn "NEXT COMB";
    	my $digit =8;
    	my $dval = $combination[$digit]++;
    	while ( $digit>=0 and $dval >= 2 ) { # carry left
    		$combination[$digit]=0;
    		$digit--;
    		$dval = $combination[$digit]++;
    	}
    	return $digit;
    }
    
    
## Output from perl c-44.pl
    
    1+2+34-5+67-8+9 = 100
    1+2+3-4+5+6+78+9 = 100
    1+23-4+5+6+78-9 = 100
    1+23-4+56+7+8+9 = 100
    12+3+4+5-6-7+89 = 100
    12+3-4+5+67+8+9 = 100
    123+45-67+8-9 = 100
    123+4-5+67-89 = 100
    123-45-67+89 = 100
    123-4-5-6-7+8-9 = 100
    12-3-4+5-6+7+89 = 100
    -1+2-3+4+5+6+78+9 = 100
    12 solutions found


# Rundown of the Prolog attempt

### perm_sum routines are list creators with +/- on each item
    perm_sum( X, [X],  ['+',X]). % Running total, Item, Backtrace
    perm_sum(-X, [X],  ['-',X]).
    perm_sum(XS, [X|L],['+',X|BT]) :-  perm_sum(LS,L,BT), XS is LS+X.
    perm_sum(XS, [X|L],['-',X|BT]) :-  perm_sum(LS,L,BT), XS is LS-X.

### bond_comb: bond combinations of digits (Prolog handles all of the possibilities as standard) 
    bond_comb([],X,X).							 		
    bond_comb([X|XL],Y,[X|Z]) :- bond_comb(XL,Y,Z).  % single
    bond_comb([X1,X2|XL],Y,Z) :- X12 is X1*10 + X2, 
        bond_comb([X12|XL],Y,Z). 		 % combine digits
  	
### List_to_string as I didn't like the built in way of printing a list of numbers interleaved with symbols
    list_to_string([]).
    list_to_string([X|Z]) :- display(X), list_to_string(Z). 

### run the calculation, but first making sure then length of 1-9 is right
    calc(Target,L9,BT) :-  	length(L9,9),  % Always check your input people
      bond_comb(L9,[],LComb),
      perm_sum(Target,LComb,BT),
      list_to_string(BT),format("=~d",Target),nl.

task1(Target):-calc(Target,[1,2,3,4,5,6,7,8,9],_). % use of _ to supress Backtrace printing

### bagof is the magic that explores all solutions
    ?- print("Task 1"),nl,bagof(_,task1(100),_). % Show all solutions
