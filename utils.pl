join_strings([], X) :- X = "".
join_strings([X|Rest], Final) :- join_strings(Rest, Y), string_concat(X, Y, Final).

null_padded(X, Res) :-
  atom_number(X, Y),
  Y < 10,
  string_concat("0", X, Res).
null_padded(X, Res) :-
  atom_number(X, Y),
  Y >= 10,
  Res = X.