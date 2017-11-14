#!/bin/sh

# A simple "unit test" for the parser

today=`date +%F`
this_year=`date +%Y`
num=1
retval=0

function test {
  echo "$num: Testing $1"
  result=`swipl -q -f parser.pl -t "find_dates." -- "$2"`
  if [ $result == $3 ]
  then
    echo "SUCCESS"
  else
    echo "FAILED!"
    echo "Expected \"$3\", got \"$result\""
    retval=1
  fi
  num=$((num+1))
}

test "basic features" "A date 01.10.2001 is history. It was not today. But 2020/10/31 is in the future" "[2001-10-01,$today,2020-10-31]"
test "date in multiple words with text" "Happens on 1st Jan 2018 at night or on November 25th 2020" "[2020-11-25,2018-01-01]"
test "invalid dates" "30.2.2000 or Feb 30th 2000" "[]"
test "date withouth year" "It's 20th January or December 31st" "[$this_year-12-31,$this_year-01-20]"
test 'date with "of"' "4th of June this year was warmer than 28th of February 1910" "[1910-02-28,$this_year-06-04]"
test 'date with "of" at the end' "This is the end: 6th of March" "[$this_year-03-06]"

exit $retval
