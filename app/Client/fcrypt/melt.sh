#!/bin/bash
DIR=$(pwd)
cd /deme/dmHaxe17/app/Client/fcrypt/www
java -jar /deme/closure/compiler.jar --compilation_level ADVANCED --js index.js --js_output_file index2.js
SCRIPT=$(cat index2.js)
HTML0=$(cat indexTemplate0.html)
HTML1=$(cat indexTemplate1.html)
echo "$HTML0$SCRIPT$HTML1" > fcrypt.html
rm index2.js
cd $DIR
