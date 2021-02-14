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
	icpc -g3 -fopenmp -O3 -xhost --std=c++0x step-1.cpp -o $(NAME)
	python create_initial_conditions.py $(CONDITIONS) --snapshots 0.0 --executable-name ./$(NAME)
	chmod 777 ./$(NAME).sh

profile-and-view: profile-step-1
	valgrind --tool=callgrind `cat $(NAME).sh`
	kcachegrind `find . -name "callgrind.out.*" -print0 | xargs -r -0 ls -1 -t | head -1`

step-1:
	icpc -fopenmp -O3 -xhost --std=c++0x step-1.cpp -o step-1.out
	cp step-1.out /ddn/data/zrlr73/Tests1
	icpc -fopenmp -O3 -xhost -g --std=c++0x step-1.cpp -o step-1.g.out
	cp step-1.g.out /ddn/data/zrlr73/Tests1

step-2:
	icpc -fopenmp -O3 -xhost --std=c++0x step-2.cpp -o step-2.out
	cp step-2.out /ddn/data/zrlr73/Tests2
	icpc -fopenmp -O3 -xhost -g --std=c++0x step-2.cpp -o step-2.g.out
	cp step-2.g.out /ddn/data/zrlr73/Tests2

step-3:
	icpc -fopenmp -O3 -xhost --std=c++0x step-3.cpp -o step-3.out
	cp step-3.out /ddn/data/zrlr73/Tests3
	icpc -fopenmp -O3 -xhost -g --std=c++0x step-3.cpp -o step-3.g.out
	cp step-3.g.out /ddn/data/zrlr73/Tests3

step-4:
	icpc -fopenmp -O3 -xhost --std=c++0x step-4.cpp -o step-4.out
	cp step-4.out /ddn/data/zrlr73/Tests4
	icpc -fopenmp -O3 -xhost -g --std=c++0x step-4.cpp -o step-4.g.out
	cp step-4.g.out /ddn/data/zrlr73/Tests4

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
