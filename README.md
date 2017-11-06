# Prolog Date Extractor

Finds dates from a string and returns ISO-formatted date strings ("YYYY-MM-DD")
for all found dates. Dates in the original source string can be something like
"1/1/2000" or "yesterday".

## Example usage

From command line:
```
$ swipl -q -f parser.pl -t "find_dates." -- "Here goes a string with possible dates, such as 1.1.2010 or yesterday"
[2010-01-01,2017-11-05]
```

... or from the Prolog interpreter:
```
$ swipl -q parser.pl
?- find_dates("Here goes a string with possible dates, such as 1.1.2010 or today", Result).
Result = "2010-01-01" ;
Result = "2017-11-06" ;
false.
```
