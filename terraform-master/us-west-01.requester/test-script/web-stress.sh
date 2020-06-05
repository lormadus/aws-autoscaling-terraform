#!/usr/bin/env bash

for i in $(seq $1); do
    curl -s $2 > /dev/null
    echo $i
done