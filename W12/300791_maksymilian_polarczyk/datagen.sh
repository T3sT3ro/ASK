pwrs=(512 1024 2048 4096 8192 16364)
touch 'matmul.dat'

function matmult {
    TM=(./matmul -n $1 -v $2 | grep "Time")
    echo $TM
}

for sz in "${pwrs[@]}"
do
    TM=0
    for i in {1..10}
    do

    done
done