:- consult("date_definitions.pl").
:- consult("utils.pl").

date_with_numbers_and_text(X1, X2, X3, Date) :-
  date_with_textual_month(X1, X2, X3, Date);
  date_with_textual_month(X2, X1, X3, Date).

date_with_numbers_and_text(X1, X2, Date) :-
  date_with_textual_month_and_without_year(X1, X2, Date);
  date_with_textual_month_and_without_year(X2, X1, Date).


/* first version for dates that include a year, the second for dates
   that are assumed to be for the current year. */
date_with_textual_month(Day, Month, Year, Date) :-
  year(Year),
  month_text(Month, MonthNum),
  number_with_ending(Day, DayStripped),
  day_num(DayStripped, MonthNum, Year),
  zero_padded(MonthNum, MonthPadded),
  zero_padded(DayStripped, DayPadded),
  join_strings([Year,"-",MonthPadded,"-",DayPadded], Date).

date_with_textual_month(Day, Month, NotYear, Date) :-
  not(year(NotYear)),
  date_with_textual_month_and_without_year(Day, Month, Date).


date_with_textual_month_and_without_year(Day, Month, Date) :-
  get_year(YearNum),
  number_string(YearNum, Year),
  date_with_textual_month(Day, Month, Year, Date).

/* TODO: use a custom timezone */
get_year(Year) :-
  get_time(Stamp),
  stamp_date_time(Stamp, Date, local),
  date_time_value(year, Date, Year).


/* just accept something like 2th for now... */
number_ending("st").
number_ending("nd").
number_ending("rd").
number_ending("th").

number_with_ending(X, WithoutEnding) :-
  string_concat(NumStr, Ending, X),
  number_ending(Ending),
  atom_number(NumStr, NumWithoutEnding),
  number_string(NumWithoutEnding, WithoutEnding).
