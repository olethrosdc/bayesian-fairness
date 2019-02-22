# Run the dirichlet results in parallel
# do 10 runs
for i in 0 1 2 3 4 5 6 7 8 9
do
	# Examnine 5 values of lambda
	for k in 0.0 0.25 0.5 0.75 1.0
	do
		# Save the result here
		fname=ce-dirichlet-result-long-${i}-${k}.dat
		sem -j6 --id "ce-dir" "octave-cli -q RunCEDirichlet.m ${fname} ${k}" >out${i}
	done
done

	
	
