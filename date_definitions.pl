year(X) :-
  atom_number(X, Y),
  Y > 0,
  Y < 9999.

month(X, Num) :- month_num(X), Num = X.
month(X, Num) :- month_text(X, Num).

month_text(X, Num) :-
  string_lower(X, Lower),
  month_text_lowercase(Lower, Num).
month_text_lowercase(X, Num) :- member(X, ["january", "jan"]), Num = "01".
month_text_lowercase(X, Num) :- member(X, ["february", "feb"]), Num = "02".
month_text_lowercase(X, Num) :- member(X, ["march", "mar"]), Num = "03".
month_text_lowercase(X, Num) :- member(X, ["april", "apr"]), Num = "04".
month_text_lowercase(X, Num) :- member(X, ["may"]), Num = "05".
month_text_lowercase(X, Num) :- member(X, ["june", "jun"]), Num = "06".
month_text_lowercase(X, Num) :- member(X, ["july", "jul"]), Num = "07".
month_text_lowercase(X, Num) :- member(X, ["august", "aug"]), Num = "08".
month_text_lowercase(X, Num) :- member(X, ["september", "sep"]), Num = "09".
month_text_lowercase(X, Num) :- member(X, ["october", "oct"]), Num = "10".
month_text_lowercase(X, Num) :- member(X, ["november", "nov"]), Num = "11".
month_text_lowercase(X, Num) :- member(X, ["december", "dec"]), Num = "12".

month_num(X) :-
  atom_number(X, Y),
  Y > 0,
  Y =< 12.

day_num(X, Month, Year) :-
  atom_number(X, D),
  atom_number(Month, M),
  atom_number(Year, Y),
  D > 0,
  day_within_month(D, M, Y).

day_within_month(X, Month, Year) :-
  (long_month(Month), X =< 31) ;
  (middle_month(Month), X =< 30) ;
  (short_month(Month, Year), X =< 28) ;
  (leap_short_month(Month, Year), X =< 29).

long_month(X) :- member(X, [1, 3, 5, 7, 8, 10, 12]).

middle_month(X) :- member(X, [4, 6, 9, 11]).

short_month(X, Year) :-
  X = 2, \+ leap_year(Year).

leap_short_month(X, Year) :-
  X = 2, leap_year(Year).

/* on purpose ignoring the "every 100 years something" rules for now... */
leap_year(Y) :-
  0 is mod(Y, 4).


/* XXX: holidays are complicated. What exactly is christmas (24. or 25.)?
  Easter changes the whole time. New year requires multiple words....
date_holiday(Str, Date) :-
  string_lower(Str, Lower),
  date_holiday_lowercase(Lower, Date).
date_holiday_lowercase("christmas", "12-25").
*/
