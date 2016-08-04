#!/bin/bash
i=1
s1=1
s=`cat url.txt |wc -l`
while [ $i -lt $s ]; do
  name=`sed ''$i'!d' url.txt`
  echo $name
  curl http://www.alexa.com/siteinfo/$name | grep -Po "^([\d,]+)\s+" >> log.txt
  if [ -s log.txt ]
    then
      sed ''$s1'!d' log.txt >> newlog.txt
      rm log.txt
    else
      echo "0" >> newlog.txt
  fi
  echo `sed ''$i'!d' url.txt`';' `sed ''$i'!d' newlog.txt` >> rank.txt
  let "i = $i + 1"
  sleep 5
done
rm newlog.txt
