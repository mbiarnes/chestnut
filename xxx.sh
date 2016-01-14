#!/bin/sh

toDo=$(git status)
echo $toDo

if [[ $toDo == "*nothing added to commit*" ]] ; then
   echo "Nothing to commit"
else
  echo "A lot of commits"
fi
