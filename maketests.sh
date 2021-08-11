#!/bin/bash

if ! CFLAGS="-D TESTING" CPPFLAGS="-D TESTING" make -s solution
then
    echo Need make-able solution.
    exit 1
fi

if test -f subtasks.csv
then
    rowid=0
    testid=1

    export generator=generator
    cnt=1

    while IFS=',' read -ra row
    do
        if [ $rowid -eq  0 ]
        then
            headers=("${row[@]}")
        else
            export taskid=$rowid

            for i in "${!headers[@]}"
            do
                t=${row[$i]//[[:space:]]/}
                if [ -n "$t" ]
                then
                    if [ "${headers[$i]}" == '#' ]
                    then
                        cnt=${row[$i]}
                    else
                        export "${headers[$i]}=$t"
                    fi
                fi
            done

            for i in $(seq 1 "$cnt")
            do
                echo Making test $testid

                if ! CFLAGS="-D TESTING" CPPFLAGS="-D TESTING" make -s $generator
                then
                    echo Need make-able generator.
                    exit 1
                fi

                if ! testid=$testid intaskid=$i ./$generator > test"$testid".in
                then
                    echo 'Test generator failed.'
                    exit 1
                fi

                if ! testid=$testid intaskid=$i ./solution < test"$testid".in > test"$testid".ok
                then
                    echo 'Solution failed.'
                fi

                testid=$((testid+1))
            done
        fi
        rowid=$((rowid+1))
    done < subtasks.csv
else
    echo Need subtasks.csv file.
    exit 1
fi
