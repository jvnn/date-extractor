:- consult("utils.pl").
:- consult("date_definitions.pl").
:- consult("multiword_dates.pl").

/* for usage from command line:
  swipl -q -f parser.pl -t "find_dates." -- <here a string with possible dates> */
find_dates() :-
  current_prolog_flag(argv, [Arg|_]),
  findall(Date, find_dates(Arg, Date), Res),
  writeln(Res).

/* for interactive usage from the interpreter */
find_dates(In, Res) :-
  split_input(In, AsList),
  date_in_list(AsList, Res).

date_in_list([X|Rest], Date) :-
  date_normal(X, Date);
  date_reverse(X, Date);
  date_human(X, Date);
  date_in_list(Rest, Date).

/* things like "1st of January 2010" */
date_in_list([X1,X2,X3,X4|_], Date) :-
  date_with_numbers_and_text(X1, X2, X3, X4, Date).

date_in_list([X1,X2,X3|_], Date) :-
  date_with_numbers_and_text(X1, X2, X3, Date).

/* Edge cases: for the end of list where above rules would fail */
date_in_list([X1,X2|[]], Date) :-
  date_with_numbers_and_text(X1, X2, Date).

date_in_list([X1,X2,X3|[]], Date) :-
  X2 = "of",
  date_with_numbers_and_text(X1, X3, Date).

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


date_human("today", Date) :- today(Date).
date_human("tomorrow", Date) :- tomorrow(Date).
date_human("yesterday", Date) :- yesterday(Date).
date_human([X|Rest], Date) :- date_human(X, Date); date_human(Rest, Date).

today(X) :-
  get_time(Time),
  format_time(string(X), "%Y-%m-%d", Time).

tomorrow(X) :-
  get_time(Time),
  TimeYesterday is Time + (24*60*60),
  format_time(string(X), "%Y-%m-%d", TimeYesterday).

yesterday(X) :-
  get_time(Time),
  TimeYesterday is Time - (24*60*60),
  format_time(string(X), "%Y-%m-%d", TimeYesterday).
