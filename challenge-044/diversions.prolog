% Task 1
perm_sum( X, [X],  ['+',X]). % Value, Item, Backtrace
perm_sum(-X, [X],  ['-',X]).
perm_sum(XS, [X|L],['+',X|BT]) :-  perm_sum(LS,L,BT), XS is LS+X.
perm_sum(XS, [X|L],['-',X|BT]) :-  perm_sum(LS,L,BT), XS is LS-X.
bond_comb([],X,X).							 		
bond_comb([X|XL],Y,[X|Z]) :- bond_comb(XL,Y,Z).  % single
bond_comb([X1,X2|XL],Y,Z) :- X12 is X1*10 + X2, 
	bond_comb([X12|XL],Y,Z). 					 % combine
list_to_string([]).
list_to_string([X|Z]) :- display(X), list_to_string(Z).
calc(Target,L9,BT) :-  	length(L9,9),
	bond_comb(L9,[],LComb),
	perm_sum(Target,LComb,BT),
	list_to_string(BT),format("=~d",Target),nl.
	
task1(Target):-calc(Target,[1,2,3,4,5,6,7,8,9],_). % use of _ to supress Backtrace printing

?- print("Task 1"),nl,bagof(_,task1(100),_). % Show all solutions

% Task2 
% day_seq(1,_,[]).
% day_seq(NextVal,PrevVal,BT) :- NextVal is PrevVal *2, PrevVal < 100 , day_seq(PrevVal,_,BT).
% day_seq(NextVal,PrevVal,BT) :- NextVal is PrevVal +1, PrevVal < 100 , day_seq(PrevVal,_,BT).

