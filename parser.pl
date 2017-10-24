:- consult("utils.pl").
:- consult("date_definitions.pl").

is_date(X, Date) :-
  date_normal(X, Date);
  date_reverse(X, Date).
is_date([X|Rest], Date) :-
  date_human(X, Date);
  is_date(Rest, Date).

/*
  normal: e.g. 1/1/2000
  reverse: e.g. 2010-12-9
 */
date_normal([X1,X2,X3,X4,X5|_], Date) :-
  month(X3, Month_num),
  day_num(X1,Month_num,X5),
  sep(X2),
  sep(X4),
  year(X5),
  null_padded(X3, MonthPadded),
  null_padded(X1, DayPadded),
  join_strings([X5,"-",MonthPadded,"-",DayPadded], Date).
date_reverse([X1,X2,X3,X4,X5|_], Date) :-
  month(X3, Month_num),
  year(X1),
  sep(X2),
  sep(X4),
  day_num(X5,Month_num,X1),
  null_padded(X3, MonthPadded),
  null_padded(X5, DayPadded),
  join_strings([X1,"-",MonthPadded,"-",DayPadded], Date).


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
