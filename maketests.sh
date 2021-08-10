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

    while IFS=',' read -ra row
    do
        if [ $rowid -eq  0 ]
        then
            headers=("${row[@]}")
        else
            unset cnt

            export taskid=$rowid

            for i in "${!headers[@]}"
            do
                if [ "${headers[$i]}" == '#' ]
                then
                    cnt="${row[$i]}"
                else
                    export "${headers[$i]}=${row[$i]}"
                fi
            done

            if [ -v cnt ]
            then
                for i in $(seq 1 $cnt)
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
            else
                echo 'subtasks.csv needs # column for number of tests per subtask'
                exit 1
            fi
        fi
        rowid=$((rowid+1))
    done < subtasks.csv
else
    echo Need subtasks.csv file.
    exit 1
fi
