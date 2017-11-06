#!/bin/sh

# A simple "unit test" for the parser

today=`date +%F`
expected="[2001-10-01,$today,2020-10-31]"

retval=`swipl -q -f parser.pl -t "find_dates." -- "A date 01.10.2001 is history. It was not today. But 2020/10/31 is in the future"`
if [ $retval == $expected ]
then
  echo SUCCESS
  exit 0
else
  echo FAILED
  exit 1
fi
