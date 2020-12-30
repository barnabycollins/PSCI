all: profile-and-view

CONDITIONS = --final-time 100 --snapshots 0.01 --dt 0.001 --executable-name ./step-1.profile.out --min-mass 0.001 --max-mass 0.005 --N 4

compile-step-1:
	icpc -fopenmp -O3 -xhost --std=c++0x step-1.cpp -o step-1.out
	python create_initial_conditions.py $(CONDITIONS)

debug-step-1:
	icpc -pg -fopenmp -O3 -xhost --std=c++0x step-1.cpp -o step-1.debug.out
	python create_initial_conditions.py $(CONDITIONS)

profile-step-1:
	icpc -g3 -fopenmp -O0 -xhost --std=c++0x step-1.cpp -o step-1.profile.out
	python create_initial_conditions.py $(CONDITIONS) --snapshots 0.0 

profile-and-view: profile-step-1
	valgrind --tool=callgrind `cat step-1.profile.out.sh`
	kcachegrind `find . -name "callgrind.out.*" -print0 | xargs -r -0 ls -1 -t | head -1`

clear-results:
	rm *.vtp *.pvd

gen-call-tree:
	gprof2dot -f callgrind $(PROFILEFILE) | dot -Tpng -o output.png
