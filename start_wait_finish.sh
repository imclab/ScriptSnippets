#!/bin/bash

for i in `seq 4 6`; do
	echo "STARTING "$i
	./task.sh &
	STARTED[$i]=$!
done

for i in `seq 4 6`; do
	echo "WAITING "${STARTED[$i]}
	wait ${STARTED[$i]}
	echo "FINSIHED "${STARTED[$i]}
done

echo "Finished"