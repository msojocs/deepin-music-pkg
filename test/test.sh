#!/bin/bash
TEST=ABC
TEST+=" DDD"
echo $TEST
for t in $TEST; do
  echo $t
done