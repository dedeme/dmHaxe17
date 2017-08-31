#!/bin/bash

read
RQ="$REPLY"

CTRL=""
CTRL=$CTRL$(echo $RQ | grep -e '^/deme/dmHaxe17/app/CServer/Hconta/server/Hconta')
CTRL=$CTRL$(echo $RQ | grep -e '^/deme/dmHaxe17/app/CServer/News/server/News')
CTRL=$CTRL$(echo $RQ | grep -e '^/deme/dmGo/bin/news')

if [ $CTRL="" ]
then
  exit 1
fi

RP=`$RQ`

EX=$(echo $?)
if [ $EX == "1" ]
then
  RP="Error code 1 - General Error: "$RP
elif [ $EX == "134" ]
then
  RP="Error code 134 - Program Abort: "$RP
elif [ $EX == "136" ]
then
  RP="Error code 136 - Erroneous Arithmetic Operation: "$RP
elif [ $EX == "139" ]
then
  RP="Error code 139 - Segmentation Fault: "$RP
elif [ $EX == "255" ]
then
  RP="Error code 255 - Program Timed Out: "$RP
elif [ $EX != "0" ]
then
  RP="Error code "$EX" - Unknown error: "$RP
fi

#RP=`echo "$RP" | base64 -w 0`
echo "Content-type: text/plain"

echo ""
echo "$RP"

