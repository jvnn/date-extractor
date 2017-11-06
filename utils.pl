join_strings([], X) :- X = "".
join_strings([X|Rest], Final) :- join_strings(Rest, Y), string_concat(X, Y, Final).


null_padded(X, Res) :-
  atom_number(X, Y),
  Y < 10,
  number_string(Y, NumStr),
  string_concat("0", NumStr, Res).
null_padded(X, Res) :-
  atom_number(X, Y),
  Y >= 10,
  Res = X.


empty_stripped([], []).
empty_stripped([""|Rest], Out) :-
  empty_stripped(Rest, Out).
empty_stripped([E|Rest], [E|Out]) :-
  E \= "",
  empty_stripped(Rest, Out).


split_input(Str, Out) :-
  split_string(Str, " ", "\t\n,.;:", List),
  empty_stripped(List, Out).


split_by_separator(X, Sep, Ret) :-
  string_chars(X, Chars),
  split_numbers_with_separator("", Chars, Sep, Ret).

split_numbers_with_separator(Before, [], _, [Before]).
split_numbers_with_separator(Before, [C|Rest], Sep, [Before|Ret]) :-
  text_to_string(C, StrChar),
  StrChar = Sep,
  split_numbers_with_separator("", Rest, Sep, Ret).
split_numbers_with_separator(Before, [C|Rest], Sep, Ret) :-
  text_to_string(C, StrChar),
  number_string(_, StrChar),
  join_strings([Before, StrChar], NewBefore),
  split_numbers_with_separator(NewBefore, Rest, Sep, Ret).
