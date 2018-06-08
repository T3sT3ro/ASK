MT0=0
MT1=0
MT2=0
MT3=0
for i in {1..10}
do
	MT0=$(echo $(./matmult -n 512 -v 0 | grep -oP 'Time elapsed: \K([0-9]+\.[0-9]+)' | bc) + $MT0 | bc)
	MT1=$(echo $(./matmult -n 512 -v 1 | grep -oP 'Time elapsed: \K([0-9]+\.[0-9]+)' | bc) + $MT1 | bc)
	MT2=$(echo $(./matmult -n 512 -v 2 | grep -oP 'Time elapsed: \K([0-9]+\.[0-9]+)' | bc) + $MT2 | bc)
	MT3=$(echo $(./matmult -n 512 -v 3 | grep -oP 'Time elapsed: \K([0-9]+\.[0-9]+)' | bc) + $MT3 | bc)
done
MT0=$(echo $MT0 / 10 | bc -l)
MT1=$(echo $MT1 / 10 | bc -l)
MT2=$(echo $MT2 / 10 | bc -l)
MT3=$(echo $MT3 / 10 | bc -l)
echo $MT0 $MT1 $MT2 $MT3 >>> datasheet.dat