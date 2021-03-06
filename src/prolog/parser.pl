:- consult("utils.pl").
:- consult("date_definitions.pl").
:- consult("multiword_dates.pl").
:- consult("relative_dates.pl").

/* for usage from command line:
  swipl -q -f parser.pl -t "find_dates." -- <here a string with possible dates> */
find_dates() :-
  current_prolog_flag(argv, [Input, TimezoneOffsetStr|_]),
  atom_number(TimezoneOffsetStr, TimezoneOffset),
  find_all_dates(TimezoneOffset, Input).

find_dates() :-
  current_prolog_flag(argv, [Arg]),
  find_all_dates(0, Arg).

find_all_dates(TimezoneOffset, In) :-
  findall(Date, find_dates(TimezoneOffset, In, Date), Res),
  writeln(Res).

/* for interactive usage from the interpreter */
find_dates(In, Res) :-
  find_dates(0, In, Res).

find_dates(TimezoneOffset, In, Res) :-
  string_lower(In, Lower),
  split_input(Lower, AsList),
  date_in_list(TimezoneOffset * 60, AsList, Res).

date_in_list(TimezoneOffset, List, Date) :-
  date_with_numbers_and_text(List, Date);
  date_relative(TimezoneOffset, List, Date).

date_in_list(TimezoneOffset, [X|Rest], Date) :-
  date_normal(X, Date);
  date_reverse(X, Date);
  date_in_list(TimezoneOffset, Rest, Date).

/*
  normal: e.g. 1/1/2000
  reverse: e.g. 2010-12-9
 */
date_normal(X, Date) :-
  looks_like_date(X, [X1,X2,X3]),
  valid_date(X1, X2, X3, Date).
date_reverse(X, Date) :-
  looks_like_date(X, [X1,X2,X3]),
  valid_date(X3, X2, X1, Date).

looks_like_date(X, Ret) :-
  split_by_separator(X, "/", Ret);
  split_by_separator(X, "-", Ret);
  split_by_separator(X, ".", Ret).

valid_date(D, M, Y, Date) :-
  year(Y),
  month(M, MonthNum),
  day_num(D, MonthNum, Y),
  zero_padded(M, MonthPadded),
  zero_padded(D, DayPadded),
  join_strings([Y,"-",MonthPadded,"-",DayPadded], Date).
