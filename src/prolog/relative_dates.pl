/* things like "yesterday", "a week ago", "two days ago", "a week from now", "in two days" */

date_relative(TimezoneOffset, ["today"|_], Date) :- today(TimezoneOffset, Date).
date_relative(TimezoneOffset, ["tomorrow"|_], Date) :- tomorrow(TimezoneOffset, Date).
date_relative(TimezoneOffset, ["yesterday"|_], Date) :- yesterday(TimezoneOffset, Date).

date_relative(TimezoneOffset, [X1,X2,X3|_], Date) :-
  as_number(X1, Number),
  time_value(X2, InSeconds),
  X3 = "ago",
  get_date(-1 * Number * InSeconds - TimezoneOffset, Date).

date_relative(TimezoneOffset, [X1,X2,X3|_], Date) :-
  (X1 = "in"; X1 = "after"),
  as_number(X2, Number),
  time_value(X3, InSeconds),
  get_date(Number * InSeconds - TimezoneOffset, Date).

date_relative(TimezoneOffset, [X1,X2,X3,X4|_], Date) :-
  as_number(X1, Number),
  time_value(X2, InSeconds),
  X3 = "from",
  X4 = "now",
  get_date(Number * InSeconds - TimezoneOffset, Date).


as_number("a", 1).
as_number("one", 1).
as_number("two", 2).
as_number("three", 3).
as_number("four", 4).
as_number("five", 5).
as_number("six", 6).
as_number("seven", 7).
as_number("eight", 8).
as_number("nine", 9).
as_number("ten", 10).
as_number("eleven", 11).
as_number("twelve", 12).
as_number(X, Number) :-
  atom_number(X, Number).

time_value("day", 24*60*60).
time_value("days", 24*60*60).
time_value("week", 7*24*60*60).
time_value("weeks", 7*24*60*60).
/* TODO:
   Month gets complicated: it's not always fix amount of days and adding/subtracting
   some amount of months from a date requires checking if the year changes etc. */


today(TimezoneOffset, X) :-
  get_time(Time),
  FinalTime is Time - TimezoneOffset,
  format_time(string(X), "%Y-%m-%d", FinalTime).

tomorrow(TimezoneOffset, X) :-
  get_time(Time),
  TimeTomorrow is Time + (24*60*60) - TimezoneOffset,
  format_time(string(X), "%Y-%m-%d", TimeTomorrow).

yesterday(TimezoneOffset, X) :-
  get_time(Time),
  TimeYesterday is Time - (24*60*60) - TimezoneOffset,
  format_time(string(X), "%Y-%m-%d", TimeYesterday).


get_date(TimeDifference, Date) :-
  get_time(Now),
  FinalTime is Now + TimeDifference,
  format_time(string(Date), "%Y-%m-%d", FinalTime).
