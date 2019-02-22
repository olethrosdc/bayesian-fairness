for i in 0 1 2 3 4 5 6 7 8 9
do
	fname=cefd-result-${i}.dat
	sem -j6 --id "cefd" "octave-cli -q RunCEFD.m ${fname}" >out${i}
done

	
	
