#!/bin/bash

# A simple "unit test" for the parser

today=`date +%F`
this_year=`date +%Y`
num=1
retval=0
timestamp_now=`date +%s`
timestamp_yesterday=$((timestamp_now - 24*60*60))
yesterday=`date -d @$timestamp_yesterday +%F`
timestamp_tomorrow=$((timestamp_now + 24*60*60))
tomorrow=`date -d @$timestamp_tomorrow +%F`
timestamp_three_weeks_ago=$((timestamp_now - 3*7*24*60*60))
three_weeks_ago=`date -d @$timestamp_three_weeks_ago +%F`
timestamp_in_two_days=$((timestamp_now + 2*24*60*60))
in_two_days=`date -d @$timestamp_in_two_days +%F`

function test {
  echo "$num: Testing $1"
  result=`swipl -q -f "src/prolog/parser.pl" -t "find_dates." -- "$2" "$4"`
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

test "basic features" "A date 01.10.2001 is history. It was not today. But 2020/10/31 is in the future" "[2001-10-01,$today,2020-10-31]" 0
test "date in multiple words with text" "Happens on 1st Jan 2018 at night or on November 25th 2020" "[2018-01-01,2020-11-25]" 0
test "invalid dates" "30.2.2000 or Feb 30th 2000" "[]" 0
test "date withouth year" "It's 20th January or December 31st" "[$this_year-01-20,$this_year-12-31]" 0
test 'date with "of"' "4th of June this year was warmer than 28th of February 1910" "[$this_year-06-04,1910-02-28]" 0
test 'date with "of" at the end' "This is the end: 6th of March" "[$this_year-03-06]" 0
test "relative dates" "Tomorrow is in 2 days after yesterday or in a day, but not three weeks ago" "[$tomorrow,$in_two_days,$yesterday,$tomorrow,$three_weeks_ago]" 0
test "timezone offset" "today" "[$yesterday]" 1440

exit $retval
