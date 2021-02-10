all: profile-and-view

CONDITIONS = --final-time 100 --snapshots 0.01 --dt 0.001 --min-mass 0.001 --max-mass 0.005 --N 4

compile-step-1:
	NAME = step-1.out
	icpc -fopenmp -O3 -xhost --std=c++0x step-1.cpp -o $(NAME)
	python create_initial_conditions.py $(CONDITIONS) --executable-name ./$(NAME)
	chmod 777 ./$(NAME).sh

debug-step-1:
	NAME = step-1.d.out
	icpc -pg -fopenmp -O3 -xhost --std=c++0x step-1.cpp -o $(NAME)
	python create_initial_conditions.py $(CONDITIONS) --executable-name ./$(NAME) --snapshots 0.0 --final-time 1000
	chmod 777 ./$(NAME).sh

profile-step-1:
	NAME = step-1.p.out
	icpc -g3 -fopenmp -O0 -xhost --std=c++0x step-1.cpp -o $(NAME)
	python create_initial_conditions.py $(CONDITIONS) --snapshots 0.0 --executable-name ./$(NAME)
	chmod 777 ./$(NAME).sh

profile-and-view: profile-step-1
	valgrind --tool=callgrind `cat $(NAME).sh`
	kcachegrind `find . -name "callgrind.out.*" -print0 | xargs -r -0 ls -1 -t | head -1`

get-compiler-report:
	icpc -qopt-report=5 -fopenmp -O3 -xhost --std=c++0x step-2.cpp -o step-2.out

clear-results:
	rm *.vtp *.pvd

step-1.5:
	icpc -qopt-report -fopenmp -O3 -xhost --std=c++0x step-1.5.cpp -o step-1.5.out

debug-step-2:
	icpc -O3 -xhost -g -fopenmp step-2.cpp -o step-2.p.out

perf-conditions:
	python3 create_initial_conditions.py --snapshots 0.0 --executable-name "step-2.p.out" --final-time 100 --dt 0.001 --min-mass 0.001 --max-mass 0.005 --N 8

gen-call-tree:
	gprof2dot -f callgrind $(PROFILEFILE) | dot -Tpng -o output.png
