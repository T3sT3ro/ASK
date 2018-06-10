MT0=0
MT1=0
echo test
for i in {1..3}
do
	s=$RANDOM
	echo $s
	MT0=$(echo $(./randwalk -S $s -n 7 -s 16 -t 14 -v 0 | grep -oP 'Time elapsed: \K([0-9]+\.[0-9]+)' | bc) + $MT0 | bc)
	MT1=$(echo $(./randwalk -S $s -n 7 -s 16 -t 14 -v 1 | grep -oP 'Time elapsed: \K([0-9]+\.[0-9]+)' | bc) + $MT1 | bc)
done
MT0=$(echo $MT0 / 3 | bc -l)
MT1=$(echo $MT1 / 3 | bc -l)
echo 3 $MT0 $MT1
