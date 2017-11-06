:- consult("utils.pl").
:- consult("date_definitions.pl").

find_dates(In, Res) :-
  split_input(In, AsList),
  date_in_list(AsList, Res).

date_in_list([X|Rest], Date) :-
  date_normal(X, Date);
  date_reverse(X, Date);
  date_human(X, Date);
  date_in_list(Rest, Date).

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
  month(M, MonthNum),
  day_num(D, MonthNum, Y),
  null_padded(M, MonthPadded),
  null_padded(D, DayPadded),
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
